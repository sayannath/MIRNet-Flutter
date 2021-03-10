```python
import tensorflow as tf

interpreter = tf.lite.Interpreter(model_path = 'lite-model_mirnet-fixed_dr_1.tflite')
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()
print("Input Shape:", input_details[0]['shape'])
print("Input Type:", input_details[0]['dtype'])
print("Output Shape:", output_details[0]['shape'])
print("Output Type:", output_details[0]['dtype'])
```

    Input Shape: [  1 400 400   3]
    Input Type: <class 'numpy.float32'>
    Output Shape: [  1 400 400   3]
    Output Type: <class 'numpy.float32'>
    


```python
import tensorflow as tf

interpreter = tf.lite.Interpreter(model_path = 'lite-model_mirnet-fixed_fp16_1.tflite')
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()
print("Input Shape:", input_details[0]['shape'])
print("Input Type:", input_details[0]['dtype'])
print("Output Shape:", output_details[0]['shape'])
print("Output Type:", output_details[0]['dtype'])
```

    Input Shape: [  1 400 400   3]
    Input Type: <class 'numpy.float32'>
    Output Shape: [  1 400 400   3]
    Output Type: <class 'numpy.float32'>
    


```python
import tensorflow as tf

interpreter = tf.lite.Interpreter(model_path = 'lite-model_mirnet-fixed_integer_1.tflite')
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()
print("Input Shape:", input_details[0]['shape'])
print("Input Type:", input_details[0]['dtype'])
print("Output Shape:", output_details[0]['shape'])
print("Output Type:", output_details[0]['dtype'])
```

    Input Shape: [  1 400 400   3]
    Input Type: <class 'numpy.float32'>
    Output Shape: [  1 400 400   3]
    Output Type: <class 'numpy.float32'>
    


```python

```
