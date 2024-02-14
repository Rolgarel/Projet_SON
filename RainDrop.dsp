declare name "bubble";
import("stdfaust.lib");


bubble(f0,trig) = os.osc(f) * (exp(-damp*time) : si.smooth(0.99))
    with {
        damp = 0.043*f0* hslider("damp", 0.5, 0, 1, 0.01) + 0.0014*f0^(3/2) ; //V
        f = f0*(1+sigma*time) * hslider("f", 0.5, 0, 1, 0.01); //V
        sigma = eta * damp ;
        eta = 0.075;
        time = 0 : (select2(trig>trig'):+(1)) ~ _ : ba.samp2sec * hslider("temps", 0.5, 0.1, 1, 0.01); //~
    };

process = button("drop") : bubble(hslider("v:bubble/freq", 600, 150, 2000, 1)) <: _,_ ;//<: dm.freeverb_demo ;