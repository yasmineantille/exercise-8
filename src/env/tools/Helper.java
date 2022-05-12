package tools;

import cartago.Artifact;
import cartago.OPERATION;
import cartago.OpFeedbackParam;

import java.util.Date;


public class Helper extends Artifact {
    Date date;

    public void init() {
        date = new Date();
    }

    @OPERATION
    public void getCurrentTimeMillisecs(OpFeedbackParam<Integer> out) {
        out.set((int) date.getTime());
    }

    @OPERATION
    public void computeReputationChange(int missionStartTime, int deadlineTime, int reputation, OpFeedbackParam<Double> out) {
        long timeRemaining = deadlineTime - date.getTime();
        if (timeRemaining > 0) { // deadline was held
            out.set(reputation + (1.0 / (date.getTime() - missionStartTime)));
        } else {
            out.set(reputation - 1.0);
        }
    }

}