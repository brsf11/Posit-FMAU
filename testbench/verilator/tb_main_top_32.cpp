#include "Vtop.h"
#include "verilated.h"

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
    Vtop* top = new Vtop{contextp, "TOP"};

    ofstream res("data/res.mat");
    ofstream err("data/err.mat");
    ofstream ser("data/ser.mat");

    double TolEr,TolSE,MaxEr,temp;
    double ME,MSE,PSNR,ERATE;

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

    long long errnum[33];
    double errrate[33];

    for(int i=0;i<33;i++)
    {
        errnum[i] = 0;
    }

    Posit32 A,B,C,D,pout = Posit32();
    float   fA,fB,fC,fD;

    for(int i=0;i<ItrNum;i++)
    {
        fA = u_rand_float(random);
        fB = u_rand_float(random);
        fC = u_rand_float(random);
        fD = u_rand_float(random);

        A.set(fA);
        B.set(fB);
        C.set(fC);
        D.set(fD);

        
        top->A = A.getBits();
        cout<<"A: "<<hex<<(unsigned)top->A<<" pA: "<<hex<<A.getBits()<<endl;
        top->B = B.getBits();
        cout<<"B: "<<hex<<(unsigned)top->B<<" pB: "<<hex<<B.getBits()<<endl;
        top->C = C.getBits();
        top->D = D.getBits();
        top->in_pre = 2;
        
        for(int j=0;j<4;j++)
        {
            top->clk = 0;
            top->eval();
            top->clk = 1;
            top->eval();
        }
        
        pout.setBits((unsigned)top->out_r);

        temp = pout.getFloat() - (fA * fB + fC * fD);
        if(temp != 0)
        {
            errNumTol++;
            errnum[(unsigned)log2(abs(temp))]++;
        }
        TolEr += temp;
        TolSE += (temp*temp);
        if(abs(temp) > MaxEr)
        {
            MaxEr = abs(temp);
        }
        if(i%sampleInt == 0)
        {
            cout<<"Sample:"<<i/sampleInt<<endl;

            axsA<<fA<<" ";
            axsB<<fB<<" ";
            axsC<<fC<<" ";
            axsD<<fD<<" ";
            err<<temp<<" ";
            sres<<pout.getFloat()<<" ";
        }
    }

    for(int i=0;i<33;i++)
    {
        errrate[i] = (double)errnum[i]/(double)errNumTol;
        errn<<errrate[i]<<" ";
    }

    ME  = (double)TolEr/(double)ItrNum;
    MSE = (double)TolSE/(double)ItrNum;
    PSNR = 10*log10((double)(MaxEr*MaxEr)/MSE);
    ERATE = (double)errNumTol/(double)ItrNum;

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
    errn.close();

    res.close();
    err.close();
    ser.close();

    delete top;
    delete contextp;
}