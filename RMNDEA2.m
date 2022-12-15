t_input1=[10808	16424	6499	11862	4758	2004	10532	1906	100	1654	1425	685	7915	4071	4368	1032	372	403	1238	6697	3100	3058	105	72];
t_input2=[222774	433673	203123	212483	120823	64157.6	199675	8195.39	712.24	53789.27	13392.55	11446.58	224216	100091	123356	43883.99	7249	7318	26007.02	115148	25079	73424	2283	2401];
intermidiate=[15633.97	20337.6	10638.3	14943.1	6044.55	3526.31	13190.9	855.36	26.5	2714.47	1121.3	479.45	10487.54	5046.31	6184.81	2256	307.12	342.38	1552.42	4164.53	1893.62	3223.28	84.54	48.93];
g_good_output1=[544387	62863	358257	485333	190815	151631	461015	21552.4	662.5	112331.9	44338.17	14058	416388.9	169419	208210.9	76844.09	10620.32	12154.49	55575.3	168067.2	63816	165039.1	3120.47	2234.54];
g_good_output2=[24237.66	24446.25	7147.89	6257.93	8212.5	5559.66	34290.54	382.69	11.31	6352.4	4604.88	1806.97	10833.98	4934.8	3420.77	265.22	354.01	71	405.54	16195.05	9563	15186.44	231.8	145.6];
g_bad_output1=[1226	2933	615	741	452	183	729	65	1	289	100	455	1049	336	480	298	79	28	65	293	142	1136	129	9];
g_bad_output2=[4620	63288	4453	2749	1662	61	2564	616	287	325	30283	7119	2266	3201	9698	104	810	469	383	2009	9521	56	4947	145];
n=size(t_input1);
N=zeros(n);
M=ones(n);
N_t=[N];
eff_t=zeros(n);
for i = 1:24
     %f is for the coefficients of the objective function
    f_t=[1 N_t];
    A_t=[0 -intermidiate ];
    b_t=[-intermidiate(i)];
    Aeq_t=[0 t_input1 
        0 t_input2 
        0 M ];
    beq_t=[t_input1(i)
        t_input2(i)
        1];
    lb=zeros(25,1);
    [x,fval] = linprog(f_t,A_t,b_t,Aeq_t,beq_t,lb);
    disp("DMU treatment SOLUTION")
    disp(fval)
    %disp(x)
    eff_t(1,i)=fval;
end


N_g=[N N -1/6 -1/6 -1/6 -1/6];
eff_g=zeros(n);
for j=1:24
    f_g=[1 N_g];
    A_g=[0 intermidiate intermidiate 0 0 0 0
        0 -g_good_output1 N g_good_output1(j) 0 0 0
        0 -g_good_output2 N 0 g_good_output2(j) 0 0
        0 g_bad_output1 N 0 0 g_bad_output1(j) 0
        0 g_bad_output2 N 0 0 0 g_bad_output2(j)];
    b_g=[intermidiate(j)
        -g_good_output1(j)
        -g_good_output2(j)
        g_bad_output1(j)
        g_good_output2(j)];
    Aeq_g=[0 M M 0 0 0 0];
    beq_g=[1];
    lb=zeros(53,1);
    [x,fval] = linprog(f_g,A_g,b_g,Aeq_g,beq_g,lb);
    disp("DMU generation SOLUTION")
    disp(fval)
    %eff_g(j,1)=fval;
end
    
