r = Synth(\DDC)


r.set(\oscOneFreq, 900, \oscTwoFreq, 0.0, \lowPassFreq, 240, \whiteNoiseMul, 0.0, \pinkNoiseMul, 0.9, \oscOneMul, 0.9, \oscTwoMul, 0.0, \oscOneLowPassFilterWet, 1, \whiteNoiseLowPassFilterWet, 0, \oscTwoLowPassFilterWet, -1, \pinkNoiseLowPassFilterWet, 0, \lowPassRq, 0.8, \lfoSpeedOne, 0, \lfoDepthOne,900, \lfoDepthTwo, 10, \lfoSpeedTwo, 2, \envSpeed, 10, \volume, 2)



(

SynthDef(\DDC ,{arg



	oscOneFreq, oscTwoFreq, lowPassFreq,

	oscOneWidth = 0.5,

    oscOneMul, oscTwoMul,  lowPassMul,

	oscOneLowPassFilterWet, whiteNoiseLowPassFilterWet, oscTwoLowPassFilterWet, pinkNoiseLowPassFilterWet, lfoWet,

	oscOneFinalOutLevel = 0.5, oscTwoFinalOutLevel = 0.5, whiteNoiseFinalOutLevel = 0.5,  pinkNoiseFinalOutLevel = 0.5, lfoFinalOutPut = 0.5,


	lowPassRq = 0.5, lfoDepthOne, lfoDepthTwo, envSpeed, volume = 1;

	var oscOne, oscTwo, out, lowPassOscOne, lowPassOscTwo, whiteNoise, lowPassWhiteNoise, pinkNoise, lowPassPinkNoise, oscOneLfo, oscTwoLfo, env;

	env = SinOsc.ar(envSpeed).range(-1,1);


	oscOneLfo = LFSaw.ar(10, 400, lfoDepthOne);

	oscTwoLfo = LFSaw.ar(10, 400, lfoDepthTwo);

	oscOne = LFPulse.ar(oscOneFreq + oscOneLfo, mul: oscOneMul, width: oscOneWidth);


	oscTwo = Mix.fill(8 , {arg i; SinOsc.ar(oscTwoLfo + oscTwoFreq*(( ( ( (i+1) *2) +1 ) )-2), mul:( (40 - (i*5) /40))*oscTwoMul) } );

	whiteNoise = WhiteNoise.ar(0.001);

	pinkNoise = PinkNoise.ar(0.001);

	lowPassOscOne = RLPF.ar(oscOne, lowPassFreq, lowPassRq);

	lowPassOscTwo = RLPF.ar(oscTwo, lowPassFreq, 0.5);

	lowPassWhiteNoise = RLPF.ar(whiteNoise, lowPassFreq, lowPassRq);

	lowPassPinkNoise = RLPF.ar(pinkNoise, lowPassFreq, lowPassRq);

	oscOne = XFade2.ar(oscOne, lowPassOscOne, oscOneLowPassFilterWet, oscOneFinalOutLevel);

	oscTwo = XFade2.ar(oscTwo, lowPassOscTwo, oscTwoLowPassFilterWet, oscTwoFinalOutLevel);

	whiteNoise =  XFade2.ar(whiteNoise, lowPassWhiteNoise, whiteNoiseLowPassFilterWet, whiteNoiseFinalOutLevel);

	pinkNoise = XFade2.ar(pinkNoise, lowPassPinkNoise, pinkNoiseLowPassFilterWet, pinkNoiseFinalOutLevel);

	out = Mix.ar([oscOne, oscTwo, whiteNoise, pinkNoise]);

	Out.ar(0,Pan2.ar(


		out*volume, level:env;

	));

}).add;

)

(
	var w, oscOneFreqKnob, masterBox, syn, oscOneMulSlider, envSpeedKnob,volumeSlider, oscLPFWetSlider, oscLPFWetSliderCS, filterFreqKnob, filtFreqSliderOneCS, filtFreqSliderOne, oscTwoFreqKnob, oscTwoMulSlider, filtFreqSliderTwo, filtFreqSliderTwoCS, filtFreqSliderWhiteNoise,  whiteNoiseMulSlider, filtFreqSliderWhiteNoiseCS, filtFreqSliderPinkNoise, filtFreqSliderPinkNoiseCS,  pinkNoiseMulSlider, whiteNoiseBox, pinkNoiseBox;
     w = Window("DDC-Synth", Rect(200, 200, 560, 500))
.alwaysOnTop_(true);
	w.view.decorator = FlowLayout(w.view.bounds, 20@20, 5@5);

c = Array.fill(4, {
	arg view;
	view = CompositeView(w, 200@200)
	.background_(Color.rand);

	view.decorator_(FlowLayout(view.bounds, 20@20, 10@10));

});

syn = Synth(\DDC);

masterBox = CompositeView(w, Rect(800,800,410,90))
.background_(Color.rand);
masterBox.decorator_(FlowLayout(masterBox.bounds, 20@20, 5@5));

oscOneFreqKnob  = Knob(c[0], 50@50);
oscOneFreqKnob.action_({
	syn.set(\oscOneFreq, 100 + (oscOneFreqKnob.value*1000));
});

oscOneMulSlider = Slider(c[0], 30@60);
oscOneMulSlider.action_({
	syn.set(\oscOneMul, oscOneMulSlider.value);
});


filtFreqSliderOne  = Slider(c[0], 30@60);
filtFreqSliderOneCS =ControlSpec(-1, 1, \lin, 1, -1);
filtFreqSliderOne.action_({
	syn.set(\oscOneLowPassFilterWet, (filtFreqSliderOneCS.map( filtFreqSliderOne.value)));
});

oscTwoFreqKnob  = Knob(c[1], 50@50);
oscTwoFreqKnob.action_({
	syn.set(\oscTwoFreq, 100 + (oscTwoFreqKnob.value*1000));
});

oscTwoMulSlider = Slider(c[1], 30@60);
oscTwoMulSlider.action_({
	syn.set(\oscTwoMul, oscTwoMulSlider.value);
});


filtFreqSliderTwo  = Slider(c[1], 30@60);
filtFreqSliderTwoCS =ControlSpec(-1, 1, \lin, 1, -1);
filtFreqSliderTwo.action_({
	syn.set(\oscTwoLowPassFilterWet, (filtFreqSliderTwoCS.map( filtFreqSliderTwo.value)));
});


whiteNoiseBox = CompositeView(c[2], Rect(0,0,90, 90))
.background_(Color.rand);
whiteNoiseBox.decorator_(FlowLayout(whiteNoiseBox.bounds, 0@0, 5@5));



whiteNoiseMulSlider = Slider(whiteNoiseBox, 20@80);
whiteNoiseMulSlider.action_({
	syn.set(\whiteNoiseMul, whiteNoiseMulSlider.value);
});

filtFreqSliderWhiteNoise  = Slider(whiteNoiseBox, 20@80);
filtFreqSliderWhiteNoiseCS =ControlSpec(-1, 1, \lin, 1, -1);
filtFreqSliderWhiteNoise.action_({
	syn.set(\whiteNoiseLowPassFilterWet, (filtFreqSliderWhiteNoiseCS .map( filtFreqSliderWhiteNoise.value)));
});


pinkNoiseBox = CompositeView(c[2], Rect(0,0,90, 90))
.background_(Color.rand);
pinkNoiseBox.decorator_(FlowLayout(pinkNoiseBox.bounds, 0@0, 5@5));


pinkNoiseMulSlider = Slider(pinkNoiseBox, 20@80);
pinkNoiseMulSlider.action_({
	syn.set(\pinkNoiseMul, pinkNoiseMulSlider.value);
});

filtFreqSliderPinkNoise  = Slider(pinkNoiseBox, 20@80);
filtFreqSliderPinkNoiseCS =ControlSpec(-1, 1, \lin, 1, -1);
filtFreqSliderPinkNoise.action_({
	syn.set(\pinkNoiseLowPassFilterWet, (filtFreqSliderPinkNoiseCS.map( filtFreqSliderPinkNoise.value)));
});





filterFreqKnob  = Knob(c[3], 50@50);
filterFreqKnob .action_({
	syn.set(\lowPassFreq, 100 + (filterFreqKnob.value * 770 ));
});



envSpeedKnob  = Knob(masterBox, 50@50);
envSpeedKnob .action_({
	syn.set(\envSpeed, (envSpeedKnob.value * 5));
});

volumeSlider  = Slider(masterBox, 30@60);
volumeSlider.action_({
	syn.set(\volume, (volumeSlider.value * 2));
});







	w.front;
    w.onClose={syn.free;};
)
