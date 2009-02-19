
import com.bit101.components.Panel;
import com.bit101.components.CheckBox;
import com.bit101.components.Label;
import com.bit101.components.PushButton;
import com.bit101.components.HSlider;
import com.bit101.components.VSlider;
import com.bit101.components.InputText;
import com.bit101.components.ProgressBar;
import com.bit101.components.RadioButton;
import com.bit101.components.ColorChooser;
import com.bit101.components.HUISlider;
import com.bit101.components.VUISlider;
import com.bit101.components.IndicatorLight;
import com.bit101.components.Knob;
import com.bit101.components.Meter;
import com.bit101.components.WheelMenu;
import flash.events.MouseEvent;

import com.bit101.components.RotarySelector;


class Main {
    static function main(){
        var m = new Main();
    }

    var panel:Panel;
    var checkBox:CheckBox;
    var label:Label;
    var pushbutton:PushButton;
    var hSlider:HSlider;
    var vSlider:VSlider;
    var inputText:InputText;
    var progressBar:ProgressBar;
    var radio1:RadioButton;
    var radio2:RadioButton;
    var radio3:RadioButton;
    var colorChooser:ColorChooser;
    var huiSlider:HUISlider;
    var vuiSlider:VUISlider;
    var light:IndicatorLight;
    var knob:Knob;
    var meter:Meter;
    var wheel:WheelMenu;
    var rselector:RotarySelector;
 
    public function new(){
        var stage = flash.Lib.current.stage;

        stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;

        panel = new Panel(stage, stage.stageWidth / 4, stage.stageHeight / 8);
        panel.setSize(stage.stageWidth / 2, stage.stageHeight * 3 / 4);       

        checkBox = new CheckBox(panel, 20, 20);
        checkBox.label = "Check it out!";

        label = new Label(panel, 20, 40);
        label.text = "This is a label";

        pushbutton = new PushButton(panel, 20, 60);
        pushbutton.label = "Push Me!";
        pushbutton.width = 100;

        hSlider = new HSlider(panel, 20, 90);
        vSlider = new VSlider(panel, 130, 20);

        inputText = new InputText(panel, 20, 110);
        inputText.text = "Input Text";

        progressBar = new ProgressBar(panel, 20, 140);
        progressBar.maximum = 100;
        progressBar.value = 32.4;

        radio1 = new RadioButton(panel, 20, 160);
        radio1.label = "Choice 1";

        radio2  = new RadioButton(panel, 20, 180);
        radio2.label = "Choice 2";

        radio3 = new RadioButton(panel, 20, 200);
        radio3.label = "Choice 3";

        colorChooser = new ColorChooser(panel, 20, 220);
        colorChooser.value = 0xff0000;

        huiSlider = new HUISlider(panel, 20, 240, "huislider");
        huiSlider.maximum = 10;
        huiSlider.minimum = 0;
        huiSlider.value = 3;
        
        vuiSlider = new VUISlider(panel, 210, inputText._y+inputText._height+15, "vuislider");
        vuiSlider.setSliderParams(0, 10, 7);

        light = new IndicatorLight(panel, 210, 20, 0xff0000, "light");

        knob = new Knob(panel, 210, 40, "knob");

        meter = new Meter(panel, 270, 20, "meter");

        wheel = new WheelMenu(panel, 3); 
        //panel.addEventListener(MouseEvent.MOUSE_DOWN, mouse_down);

        rselector = new RotarySelector(panel, 270, 220, "rselector");
    }
   
    public function mouse_down(e:flash.events.MouseEvent){
        wheel.show();
    }
}
