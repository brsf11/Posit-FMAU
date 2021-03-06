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

    double TolEr,TolSE,MaxEr,temp[2];
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

    Posit16 A[2],B[2],C[2],D[2],pout[2];
    float   fA[2],fB[2],fC[2],fD[2];

    for(int i=0;i<2;i++)
    {
        A[i]    = Posit16();
        B[i]    = Posit16();
        C[i]    = Posit16();
        D[i]    = Posit16();
        pout[i] = Posit16();
    }

    for(int i=0;i<ItrNum;i++)
    {
        fA[0] = u_rand_float(random);
        fB[0] = u_rand_float(random);
        fC[0] = u_rand_float(random);
        fD[0] = u_rand_float(random);
        fA[1] = u_rand_float(random);
        fB[1] = u_rand_float(random);
        fC[1] = u_rand_float(random);
        fD[1] = u_rand_float(random);

        A[0].set(fA[0]);
        B[0].set(fB[0]);
        C[0].set(fC[0]);
        D[0].set(fD[0]);
        A[1].set(fA[1]);
        B[1].set(fB[1]);
        C[1].set(fC[1]);
        D[1].set(fD[1]);

        
        top->A = ((A[1].getBits() << 16) | A[0].getBits());
        cout<<"A[1]:"<<hex<<A[1].getBits()<<" A[0]:"<<hex<<A[0].getBits()<<" A:"<<hex<<(unsigned)top->A<<endl;
        top->B = ((B[1].getBits() << 16) | B[0].getBits());
        top->C = ((C[1].getBits() << 16) | C[0].getBits());
        top->D = ((D[1].getBits() << 16) | D[0].getBits());
        top->in_pre = 1;
        
        for(int j=0;j<4;j++)
        {
            top->clk = 0;
            top->eval();
            top->clk = 1;
            top->eval();
        }
        
        pout[0].setBits((unsigned)top->out_r & 0x0000ffff);
        pout[1].setBits((unsigned)top->out_r >> 16);
        cout<<hex<<"out_r:"<<(unsigned)top->out_r<<" pout[1]:"<<pout[1].getBits()<<" pout[0]:"<<pout[0].getBits()<<endl;


        for(int j=0;j<2;j++)
        {
            temp[j] = pout[j].getFloat() - (fA[j] * fB[j] + fC[j] * fD[j]);
            if(temp[j] != 0)
            {
                errNumTol++;
                errnum[(unsigned)log2(abs(temp[j]))]++;
            }
            TolEr += temp[j];
            TolSE += (temp[j]*temp[j]);
            if(abs(temp[j]) > MaxEr)
            {
                MaxEr = abs(temp[j]);
            }
            if(i%sampleInt == 0)
            {
                cout<<"Sample:"<<dec<<i/sampleInt<<endl;

                axsA<<fA[j]<<" ";
                axsB<<fB[j]<<" ";
                axsC<<fC[j]<<" ";
                axsD<<fD[j]<<" ";
                err<<temp[j]<<" ";
                sres<<pout[j].getFloat()<<" ";
            }
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
    cout<<"ERATE       = "<<ERATE/2<<endl;
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