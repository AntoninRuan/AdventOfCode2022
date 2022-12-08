package day08;

public class Pair <X, Y> {

    private X key;
    private Y value;

    public Pair(X key, Y value) {
        this.key = key;
        this.value = value;
    }

    public X getKey() {
        return this.key;
    }

    public Y getValue() {
        return this.value;
    }

    public void setKey(X key) {
        this.key = key;
    }

    public void setValue(Y value) {
        this.value = value;
    }

}
