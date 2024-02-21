import("stdfaust.lib");

freq = hslider("freq",6000,1000,10000,0.01) : si.smoo;
nb_rain = 5;
rain_freq = freq + (no.multinoise(nb_rain) :> _) * freq * 1.34/nb_rain;

gain = hslider("gain",0,0,0.4,0.01) : si.smoo;
gain_noise = (no.noise * 0.5 + 0.5 ) * 0.025;
rain_gain = min(1, max(gain + gain_noise, -1));

rain_noise = no.pink_noise : fi.lowpass(1, rain_freq) * rain_gain : ef.echo(0.1, 0.1, 0.04) <: _,_;

rain_volume = hslider("volume", 1, 0, 10, 0.01);
rain = rain_noise : par(i, 2, drop) : par(i, 2, *(rain_volume))
    with {
        drop = _ <: @(1), (abs < 0.42) : *;
    };

bubble = os.osc(f) * (exp(-damp*time) : si.smooth(0.99)) + (os.osc(f - 30) * (exp(-damp2*(time-0.0001)) : si.smooth(0.99))* 0.5 : ef.echo(0.1,0.01, 0.2))
    with {
        f0 = hslider("f0", 1476, 750, 1700, 1);
        trig = button("drop");
        damp = 0.43*f0* hslider("damp", 0.5, 0.4, 0.6, 0.01) + 0.0014*f0^(3/2); 
        damp2 = 0.03*f0* hslider("damp2", 0.5, 0.4, 0.6, 0.01) + 0.0014*f0^(3/2);
        f = f0*(1+sigma*time) * hslider("f", 0.5, 0.3, 0.5, 0.01);
        sigma = eta * damp ;
        eta = 0.075;
        time = 0 : (select2(trig>trig'):+(1)) ~ _ : ba.samp2sec * hslider("time", 0.5, 0.5, 1.0, 0.01);
    };

l_drop = hslider("l_drop", 0.5, 0.1, 1.0, 0.01);
r_drop = hslider("r_drop", 0.5, 0.1, 1.0, 0.01);

rain_drop = bubble * 0.009 * rain_volume <: _ * l_drop, _ * r_drop;

sq(x) = x * x;
stretch(ms) = ba.countdown(ma.SR * ms / 2000): >(0);

rumble(dens, rel, fo) = ((no.noise : fi.lowpass(3, 100)) * 13.12 * os.osc(50 / dens) * fo
                      * en.arfe(0.05, release , 0, trigger: >(0)
                      : stretch(sus)))
                      : fi.highpass(3, 100)
    with {
        trigger = no.sparse_noise(dens + 3): abs;
        sus = 2 + (trigger: ba.latch(trigger) * 8);
        release = rel + (10.3 * (no.noise : abs : ba.latch(trigger)));
    };

crackle(dens, rel) = ((no.noise : fi.lowpass(3, 1000)) * 0.77 * os.osc(800 / dens) * 
                      en.arfe(0.001, release +2, 0, trigger: >(0)
                      : stretch(sus * 0.5)))
                      : fi.highpass(3, 500)
                      : ef.echo(0.1,0.1,0.3)
    with {
        trigger = no.sparse_noise(dens): abs;
        sus = 2 + (trigger: ba.latch(trigger) * 8);
        release = rel + (0.3 * (no.noise : abs : ba.latch(trigger)));
    };

l_bolt = hslider("l_bolt", 1, 0.1, 1.0, 0.01);
r_bolt = hslider("r_bolt", 1, 0.1, 1.0, 0.01);
b_rumble = button("rumble");

rumb(force) = rumble(0.8, 4, force) * rumble(0.8, 4, force) : fi.highpass(4, 8) : fi.lowpass(4, 1000);
cra(force) = crackle(0.5,1) * force * 5;

thunder = (rumb(force) * 12 : ef.echo(0.1, 0.1, 0.05) + cra(force2)) * 0.25 * rain_volume <: _ * l_bolt, _ * r_bolt
    with {
        force = b_rumble : ba.impulsify : en.ar(2, 5) : *(0.61);
        force2 = b_rumble : ba.impulsify : en.ar(0.3, 2) : *(0.61);
    };

process  =  rain,rain_drop,thunder :> _,_;
