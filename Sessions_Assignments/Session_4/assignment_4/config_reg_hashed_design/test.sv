module testing;
  bit [15:0] reset_assoc [string];
  string keys[];

  initial begin
    // Fill the associative array
    reset_assoc["adc0_reg_rest_val"]          = 16'hFFFF;
    reset_assoc["adc1_reg_rest_val"]          = 16'h0000;
    reset_assoc["temp_sensor0_reg_rest_val"]  = 16'h0000;
    reset_assoc["temp_sensor1_reg_rest_val"]  = 16'h0000;
    reset_assoc["analog_test_rest_val"]       = 16'hABCD;
    reset_assoc["digital_test_rest_val"]      = 16'h0000;
    reset_assoc["amp_gain_rest_val"]          = 16'h0000;
    reset_assoc["digital_config_rest_val"]    = 16'h0002;

    keys = '{
        "adc0_reg_rest_val", 
        "adc1_reg_rest_val", 
        "temp_sensor0_reg_rest_val",
        "temp_sensor1_reg_rest_val",
        "analog_test_rest_val",
        "digital_test_rest_val",
        "amp_gain_rest_val",
        "digital_config_rest_val"
    };

    foreach (keys[i]) begin
        $display("%s = %h", keys[i], reset_assoc[keys[i]]);
    end
  end
endmodule
