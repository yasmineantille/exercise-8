package tools;

import cartago.*;

public class Converter extends Artifact {

    public void init() {
    }

    // Task 3 Step 2
    // source for calculation: https://stackoverflow.com/questions/929103/convert-a-number-range-to-another-range-maintaining-ratio
    @OPERATION
    public void convert(double initValue, int sourceMin, int targetMin, int sourceMax, int targetMax, OpFeedbackParam<Integer> rescaledValue) {
        double rescaled = ((initValue - (double) sourceMin) / ((double) sourceMax - (double) sourceMin) * ((double) targetMax - (double) targetMin) + (double) targetMin);
        System.out.println((int) rescaled);
        rescaledValue.set((int) rescaled);
    }

    // for quick testing
    public static void main(String[] args) {
        Converter converter = new Converter();
        int sourceStart = -20;
        int sourceEnd = 30;
        int targetStart = 200;
        int targetEnd = 800;
        Double value = 25.0;
        System.out.println(((value - sourceStart) / (sourceEnd - sourceStart) * (targetEnd - targetStart) + targetStart));
        //converter.convert(value, sourceStart, targetStart, sourceEnd, targetEnd, new OpFeedbackParam<>());
    }
}
