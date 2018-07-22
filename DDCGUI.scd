(
	var w, oscOneFreqKnob, masterBox, syn, oscOneMulSlider, envSpeedKnob,volumeSlider, oscLPFWetSlider, oscLPFWetSliderCS, filterFreqKnob, filtFreqSliderOneCS, filtFreqSliderOne, oscTwoFreqKnob, oscTwoMulSlider, filtFreqSliderTwo, filtFreqSliderTwoCS, filtFreqSliderWhiteNoise,  whiteNoiseMulSlider, filtFreqSliderWhiteNoiseCS, filtFreqSliderPinkNoise, filtFreqSliderPinkNoiseCS,  pinkNoiseMulSlider, whiteNoiseBox, pinkNoiseBox, lfoOneDepthKnob,  lfoOneDepthKnobCS, lfoTwoDepthKnob, lfoTwoDepthKnobCS, filterRqKnob;


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



lfoOneDepthKnob = Knob(c[0], 50@60);
lfoOneDepthKnobCS =ControlSpec(0.0, 500, \lin, 0, 400);
lfoOneDepthKnob.action_({
	syn.set(\lfoDepthOne, lfoOneDepthKnobCS.map(lfoOneDepthKnob.value).postln);
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

lfoTwoDepthKnob = Knob(c[1], 50@60);
lfoTwoDepthKnobCS =ControlSpec(0.0, 500, \lin, 0, 400);
lfoTwoDepthKnob.action_({
	syn.set(\lfoDepthTwo, lfoTwoDepthKnobCS.map(lfoTwoDepthKnob.value));
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
	syn.set(\lowPassFreq, 500 + (filterFreqKnob.value * 3000 ));
});


filterRqKnob  = Knob(c[3], 50@50);
filterRqKnob .action_({
	syn.set(\lowPassRq, filterRqKnob.value + 0.4);
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


