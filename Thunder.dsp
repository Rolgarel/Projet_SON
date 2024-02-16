import("stdfaust.lib");

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

process = rumb(force) * 12 : ef.echo(0.1, 0.1, 0.05) + cra(force2) <: _ * l_bolt, _ * r_bolt
    with {
        force = b_rumble : ba.impulsify : en.ar(2, 5) : *(0.61);
        force2 = b_rumble : ba.impulsify : en.ar(0.3, 2) : *(0.61);
    };
