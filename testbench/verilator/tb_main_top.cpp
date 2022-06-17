#include "Vtop.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

#include "posit.h"

#include<iostream>
#include<fstream>
#include<cmath>
#include<random>
#include<chrono>
#include<limits>
using namespace std;
using namespace std::chrono;

#define ItrNum 100
#define SpNum 100

#define FLOAT_MIN -100.0
#define FLOAT_MAX  100.0

const int PositTable[5][2] ={{0,0} ,{32,2} , {16,1}, {16,1}, {8,0}};
const int InpreTable[5]    ={0,2,1,1,0};

vluint64_t main_time = 0;

double sc_time_stamp()
 {
     return main_time;
 }


int str2num(char* str)
{
    int num = 0;
    int i = 0;
    while(str[i] != 0)
    {
        if(str[i] >= '0' && str[i] <= '9')
        {
            num *= 10;
            num += (str[i] - '0');
        }
        i++;
    }
    return num;
}

int main(int argc, char** argv, char** env)
{
    VerilatedContext* contextp = new VerilatedContext;
    contextp->commandArgs(argc,argv);
    contextp->traceEverOn(true);
    Vtop* top = new Vtop{contextp, "TOP"};

    VerilatedVcdC* tfp = new VerilatedVcdC();

    top->trace(tfp, 0);
    tfp->open("wave/wave.vcd");

    ofstream res("data/res.mat");
    ofstream err("data/err.mat");
    ofstream ser("data/ser.mat");

    double TolEr,TolSE,MaxEr,temp;
    double ME,MSE,PSNR,ERATE;

    unsigned fcase = 0;

    TolEr = 0;
    TolSE = 0;
    MaxEr = 0;


    int bitwidth;
    if(argc == 1)
    {
        bitwidth = 8;
    }
    else
    {
        bitwidth = str2num(argv[1]);
    }

    if((bitwidth != 8) && (bitwidth != 16) && (bitwidth != 32))
    {
        cout<<"Illegal bitwidth!"<<endl;
        return 0;
    }

    const int width = 32/bitwidth;
    cout<<"width = "<<width<<endl;

    int sampleInt = ItrNum/SpNum;
    ofstream axsA("data/axsA.mat");
    ofstream axsB("data/axsB.mat");
    ofstream axsC("data/axsC.mat");
    ofstream axsD("data/axsD.mat");

    ofstream sres("data/sres.mat");
    ofstream errn("data/errn.mat");

    cout<<"Bitwidth = "<<bitwidth<<endl;
    typedef duration<int,ratio<1>> sec_type;
    time_point<system_clock,sec_type> before = time_point_cast<sec_type>(system_clock::now());
    
    default_random_engine random(before.time_since_epoch().count());
    uniform_real_distribution<float> u_rand_float(FLOAT_MIN,FLOAT_MAX);

    long long out,tempA,tempB,errNumTol=0;


    Posit* A    = new Posit[4];
    Posit* B    = new Posit[4];
    Posit* C    = new Posit[4];
    Posit* D    = new Posit[4];
    Posit* pout = new Posit[4];
    float   fA[4],fB[4],fC[4],fD[4];

    for(int i=0;i<4;i++)
    {
        A[i]    = Posit(PositTable[width][0],PositTable[width][1]);
        B[i]    = Posit(PositTable[width][0],PositTable[width][1]);
        C[i]    = Posit(PositTable[width][0],PositTable[width][1]);
        D[i]    = Posit(PositTable[width][0],PositTable[width][1]);
        pout[i] = Posit(PositTable[width][0],PositTable[width][1]);

        A[i].setBits(0);
        B[i].setBits(0);
        C[i].setBits(0);
        D[i].setBits(0);
        pout[i].setBits(0);
    }

    for(int i=0;i<ItrNum;i++)
    {
        for(int j=0;j<width;j++)
        {
            fA[j] = u_rand_float(random);
            fB[j] = u_rand_float(random);
            fC[j] = u_rand_float(random);
            fD[j] = u_rand_float(random);
            A[j].set((float)(fA[j]/10.0));
            B[j].set((float)(fB[j]/10.0));
            C[j].set((float)(fC[j]/10.0));
            D[j].set((float)(fD[j]/10.0));
        }
        
        top->A = ((A[3].getBits() << bitwidth*3) | (A[2].getBits() << bitwidth*2) | (A[1].getBits() << bitwidth*1) | A[0].getBits());
        top->B = ((B[3].getBits() << bitwidth*3) | (B[2].getBits() << bitwidth*2) | (B[1].getBits() << bitwidth*1) | B[0].getBits());
        top->C = ((C[3].getBits() << bitwidth*3) | (C[2].getBits() << bitwidth*2) | (C[1].getBits() << bitwidth*1) | C[0].getBits());
        top->D = ((D[3].getBits() << bitwidth*3) | (D[2].getBits() << bitwidth*2) | (D[1].getBits() << bitwidth*1) | D[0].getBits());
        top->in_pre = InpreTable[width];
        top->out_pre = InpreTable[width];

        top->start = 0;
        
        for(int j=0;j<6;j++)
        {
            top->clk = 0;
            top->start = (j == 0);
            top->eval();
            tfp->dump(main_time); //dump wave
            main_time++;
            top->clk = 1;
            top->start = (j == 0);
            top->eval();
            tfp->dump(main_time); //dump wave
            main_time++;
        }

        for(int j=0;j<width;j++)
        {
           pout[j].setBits(((unsigned)top->out_r >> bitwidth*j) & ((1LL << bitwidth) - 1LL));
        }


        for(int j=0;j<width;j++)
        {
            if(abs((A[j].getFloat() * B[j].getFloat()) + (C[j].getFloat() * D[j].getFloat()))>64)
            {
                fcase++;
                continue;
            }

            temp = pout[j].getFloat() - ((A[j].getFloat() * B[j].getFloat()) + (C[j].getFloat() * D[j].getFloat()));
            // temp = pout[j].getFloat() - ((fA[j] * fB[j] * 0.01) + (fC[j] * fD[j] * 0.01));
            if(temp != 0)
            {
                errNumTol++;
            }
            TolEr += temp;
            TolSE += (temp*temp);
            if(fabs(temp) > MaxEr)
            {
                MaxEr = fabs(temp);
            }
            if(i%sampleInt == 0)
            {
                cout<<"Sample:"<<dec<<i/sampleInt<<endl;
                cout<<"A["<<j<<"]="<<A[j].getFloat()<<" B["<<j<<"]="<<B[j].getFloat()<<" C["<<j<<"]="<<C[j].getFloat()<<" D["<<j<<"]="<<D[j].getFloat()<<" out["<<j<<"]="<<pout[j].getFloat()<<endl;
                cout<<"temp="<<temp<<endl;
                axsA<<fA[j]<<" ";
                axsB<<fB[j]<<" ";
                axsC<<fC[j]<<" ";
                axsD<<fD[j]<<" ";
                err<<temp<<" ";
                sres<<pout[j].getFloat()<<" ";
            }
        }
        
    }

    ME  = (double)TolEr/(double)(ItrNum*width - fcase);
    MSE = (double)TolSE/(double)(ItrNum*width - fcase);
    PSNR = 10*log10((double)(MaxEr*MaxEr)/MSE);
    ERATE = (double)errNumTol/(double)(ItrNum*width - fcase);

    cout<<"Utop"<<endl;
    cout<<"Total Error = "<<TolEr<<endl;
    cout<<"Total SE    = "<<TolSE<<endl;
    cout<<"Max Error   = "<<MaxEr<<endl;
    cout<<"ME          = "<<ME<<endl;
    cout<<"MSE         = "<<MSE<<endl;
    cout<<"ERATE       = "<<ERATE<<endl;
    cout<<"PSNR        = "<<PSNR<<endl;
    
    time_point<system_clock,sec_type> after = time_point_cast<sec_type>(system_clock::now());
    cout<<"Time used: "<<after.time_since_epoch().count() - before.time_since_epoch().count()<<" s"<<endl;

    axsA.close();
    axsB.close();
    axsC.close();
    axsD.close();
    sres.close();

    res.close();
    err.close();
    ser.close();

    delete A;
    delete B;
    delete C;
    delete D;
    delete pout;

    top->final();
    tfp->close();

    delete top;
    delete contextp;
}