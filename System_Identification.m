%% Sistem ordin 2 fara zero

data = csvread('Data\Asmarandei.csv', 2, 0);

t = data(:, 1);
u = data(:, 2);
y = data(:, 3);

figure 
plot(t,u,t,y)
title('Sistem de ordin 2 fara zero')
xlabel('Timp')
ylabel('Amplitudine')
legend('Intrare', 'Iesire')

%% Metoda neparametrica - rezonanta

i1 = 169;
i2 = 165;
i3 = 157;
i4 = 152;

Mr = (y(i2)-y(i4))/(u(i1)-u(i3))
T = (t(i2)-t(i4))*2

tita = (sqrt((Mr-sqrt(Mr^2-1)))/2*Mr)
wr = (2*pi/T)
wn = wr/sqrt(1-2*tita^2)

K = mean(y)/mean(u);

Hs = tf(K*(wn^2),[1 2*tita*wn wn^2])

[num, den] = tfdata(Hs,'v');

[A_FCC,B_FCC,C_FCC,D] = tf2ss(num,den);
A_FCO = A_FCC';
B_FCO = C_FCC';
C_FCO = B_FCC';

sys_FCO = ss(A_FCO,B_FCO,C_FCO,D);

ci = (y(2)-y(1))/(t(2)-t(1));
ysim = lsim(sys_FCO,u,t,[y(1) ci*10]);

%J = 1/sqrt(length(t))*norm(y-ysim);
empn = norm(y-ysim)/norm(y-mean(y))*100

figure 
plot(t,y,t,ysim)
hold on
title('Comparatie sistem real cu sistem estimat')
xlabel('Timp')
ylabel('Amplitudine')
legend('Sistem real', 'Sistem estimat')

%% Metode parametrice
%% ARMAX - autocorelatie

data_id = iddata(y, u, t(2)-t(1));
data_vd = iddata(y, u, t(2)-t(1));

m_armax = armax(data_id, [2 2 2 1])
figure, compare(data_vd, m_armax)
figure, resid(data_vd, m_armax)

Hd_armax = tf(m_armax)
Hc_armax = d2c(Hd_armax, 'zoh')

empn_armax = 100-95.9

%% OE - intercorelatie

m_oe = oe(data_id, [2 2 1])
figure, compare(data_vd, m_oe)
figure, resid(data_vd, m_oe)

Hd_oe = tf(m_oe)
Hc_oe = d2c(Hd_oe, 'zoh')

empn_oe = 100-95.91

%% Sistem ordin 2 cu zero

z = data(:, 4);
figure 
plot(t,u,t,z)
title('Sistem de ordin 2 cu zero')
xlabel('Timp')
ylabel('Amplitudine')
legend('Intrare', 'Iesire')

%% ARMAX - autocorelatie
close all

data_vd_z = iddata(z, u, t(2)-t(1));

m_armax_z = armax(data_vd_z, [2 2 2 1])
figure, compare(data_vd_z, m_armax_z)
figure, resid(data_vd_z, m_armax_z)

Hd_armax_z = tf(m_armax_z)
Hc_armax_z = d2c(Hd_armax_z, 'zoh')

%% OE - intercorelatie
close all

m_oe_z = oe(data_vd_z, [2 2 1])
figure, compare(data_vd_z, m_oe_z)
figure, resid(data_vd_z, m_oe_z)

Hd_oe_z = tf(m_oe_z)
Hc_oe_z = d2c(Hd_oe_z, 'zoh')


