clear

t = 0;
tf = 0;

gm = input('rating of generator MVA : ');
pd = input('power delivered by generator MW : ');

tfinal = input('enter the end time : ');
tc = input('enter fault clearing time : ');
tstep = input('enter sampling time : ');
f = input('enter frequency : ');
H = input('enter inertia constant MJ/MVA : ');

M = H / (180 * f)

Er = input('real sending end voltage V : ');
Vr = input('real part of infinite bus voltages V : ');

x1 = input('reactance under prefault condition : ');
x2 = input('reactance during fault condition: ');
x3 = input('reactance during post fault condition: ');

Pm = pd / gm

i = 2;
delta = 21.64 * pi / 180;
ddelta = 0;

time(1) = 0;
ang(1) = 21.64;

Pmaxbf = Er * Vr / x1
Pmaxdf = Er * Vr / x2
Pmaxaf = Er * Vr / x3

% Fix: Initialize Pa before while loop starts
Pa = 0.9 - Pmaxbf * sin(delta);

while (t < tfinal)

    if (t == tf)
        Paminus = 0.9 - Pmaxbf * sin(delta);
        Paplus  = 0.9 - Pmaxdf * sin(delta);
        Paav    = (Paminus + Paplus) / 2;
        Pa = Paav;
    end

    if (t == tc)
        Paminus = 0.9 - Pmaxdf * sin(delta);
        Paplus  = 0.9 - Pmaxaf * sin(delta);
        Paav    = (Paminus + Paplus) / 2;
        Pa = Paav;
    end

    if (t > tc)

        Pa = 0.9 - Pmaxdf * sin(delta);
    end

    if ((t > tf) && (t > tc))
        Pa = 0.9 - Pmaxaf * sin(delta);
    end

    ddelta = ddelta + (tstep * tstep * Pa / M);
    delta = (delta * 180 / pi + ddelta) * pi / 180;
    deltadeg = delta * 180 / pi;

    t = t + tstep;
    time(i) = t;
    ang(i) = deltadeg;
    i = i + 1;
end

h = plot(time, ang, '-ob', 'LineWidth', 1, ...
         'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 5);
grid on;

title('swingcurve');
xlabel('time in seconds');
ylabel('rotor angle');
