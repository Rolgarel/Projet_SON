import("stdfaust.lib");

stretch(ms) = ba.countdown(ma.SR * ms / 1000): >(0);

rumble(dens, rel) = ((no.noise : fi.lowpass(3, 1500)) * 0.77 * os.osc(50 / dens) * //hauteur du son // 1500 à 100 pour fond de tonerre
                      en.arfe(0.001, release, 0, trigger: >(0)
                      : stretch(sus))) // enlever definitevement
                      : fi.highpass(3, 100)
    with {
        trigger = no.sparse_noise(dens): abs; //dens + 10 pour faire  de la pluie
        sus = 2 + (trigger: ba.latch(trigger) * 8);
        release = rel + (10.3 * (no.noise : abs : ba.latch(trigger)));
    };

process =  rumble(0.8, 2) <: _ * 0.6 ,_ *0.4; //button("clicking") :

//4 à 125 Hz
//first as a clicking or cloth-tearing sound, then a cannon shot sound or loud crack/snap, followed by continuous rumbling
//rajouter un smooth
//gain 