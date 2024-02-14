import("stdfaust.lib");

freq = hslider("freq",6000,1000,10000,0.01) : si.smoo;
nb_rain = 5;
rain_freq = freq + (no.multinoise(nb_rain) :> _) * freq * 1.34/nb_rain;

gain = hslider("gain",0,0,0.5,0.01) : si.smoo;
gain_noise = (no.noise * 0.5 + 0.5 ) * 0.025;
rain_gain = min(1, max(gain + gain_noise, -1));

rain_noise = no.pink_noise : fi.lowpass(1, rain_freq) * rain_gain : ef.echo(0.1, 0.1, 0.04) <: _,_;

rain(level) = rain_noise : par(i, 2, drop) : par(i, 2, *(level))
    with {
        drop = _ <: @(1), (abs < 0.42) : *;
    };

//gate = button("gate") : si.smoo;

//process = rain_ini <: _,_;

process  =  rain(hslider("volume", 1, 0, 5, 0.01));