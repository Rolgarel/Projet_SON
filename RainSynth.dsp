import("stdfaust.lib");

freq = hslider("freq",6000,1000,10000,0.01) : si.smoo;
nb_rain = 5;
rain_freq = freq + (no.multinoise(nb_rain) :> _) * freq * 1.34/nb_rain;

gain = hslider("gain",0,0,0.4,0.01) : si.smoo;
gain_noise = (no.noise * 0.5 + 0.5 ) * 0.025;
rain_gain = min(1, max(gain + gain_noise, -1));

rain_noise = no.pink_noise : fi.lowpass(1, rain_freq) * rain_gain : ef.echo(0.1, 0.1, 0.04) <: _,_;

rain_volume = hslider("volume", 1, 0, 5, 0.01);
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

rain_drop = bubble * 0.007 * rain_volume <: _ * hslider("l_drop", 0.5, 0.0, 1.0, 0.01), _ * hslider("r_drop", 0.5, 0.0, 1.0, 0.01);

process  =  rain,rain_drop :> _,_;
