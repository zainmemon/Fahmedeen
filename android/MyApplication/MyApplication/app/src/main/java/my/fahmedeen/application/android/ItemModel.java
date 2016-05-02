package my.fahmedeen.application.android;

/**
 * Created by Wahab on 05/02/16.
 */
public class ItemModel {

    String item;
    boolean isSelected = false;

    public ItemModel(String item) {
        this.item = item;
    }

    public String getItem() {
        return item;
    }

    public void setItem(String item) {
        this.item = item;
    }

    public boolean isSelected() {
        return isSelected;
    }

    public void setSelected(boolean selected) {
        isSelected = selected;
    }
}
