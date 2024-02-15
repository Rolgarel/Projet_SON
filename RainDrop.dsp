declare name "bubble";
import("stdfaust.lib");


bubble(f0,trig) = os.osc(f) * (exp(-damp*time) : si.smooth(0.99)) + (os.osc(f - 30) * (exp(-damp2*(time-0.0001)) : si.smooth(0.99))* 0.5 : ef.echo(0.1,0.01, 0.2))
    with {
        damp = 0.43*f0* hslider("v:bubble/damp", 0.5, 0.4, 0.6, 0.01) + 0.0014*f0^(3/2) ; 
        damp2 = 0.03*f0* hslider("v:bubble/damp2", 0.5, 0.4, 0.6, 0.01) + 0.0014*f0^(3/2) ;
        f = f0*(1+sigma*time) * hslider("v:bubble/f", 0.5, 0.3, 0.5, 0.01);
        sigma = eta * damp ;
        eta = 0.075;
        time = 0 : (select2(trig>trig'):+(1)) ~ _ : ba.samp2sec * hslider("v:bubble/temps", 0.5, 0.5, 1, 0.01);
    };

process = button("v:bubble/drop") : bubble(hslider("v:bubble/freq", 1476, 150, 2000, 1)) <: _,_;