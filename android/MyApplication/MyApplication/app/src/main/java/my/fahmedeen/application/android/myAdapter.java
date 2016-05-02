package my.fahmedeen.application.android;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;

/**
 * Created by Umar on 4/27/2016.
 */
class myAdapter extends BaseAdapter {

    Context context;
    ArrayList<ItemModel> data;
    static int selectedNo = -1;
    private static LayoutInflater inflater = null;

    public myAdapter(Context context, ArrayList<ItemModel> data) {
        // TODO Auto-generated constructor stub
        this.context = context;
        this.data = data;
        inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }


    @Override
    public int getCount() {
        // TODO Auto-generated method stub
        return data.size();
    }

    @Override
    public Object getItem(int position) {
        // TODO Auto-generated method stub
        return data.get(position);
    }

    @Override
    public long getItemId(int position) {
        // TODO Auto-generated method stub
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        // TODO Auto-generated method stub
        View vi = convertView;
        if (vi == null)
            vi = inflater.inflate(R.layout.fragment_item, null);
        TextView text = (TextView) vi.findViewById(R.id.text);
        ImageView imgButton = (ImageView) vi.findViewById(R.id.imageButton);
        text.setText(data.get(position).getItem());
        if (data.get(position).isSelected) {

            imgButton.setImageResource(R.drawable.pause_icon);

        }else{

            imgButton.setImageResource(R.drawable.play_icon);

        }


        return vi;
    }
}
