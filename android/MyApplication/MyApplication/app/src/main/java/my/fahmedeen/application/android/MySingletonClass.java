package my.fahmedeen.application.android;

/**
 * Created by Umar on 4/27/2016.
 */
public class MySingletonClass {
    private static MySingletonClass ourInstance = new MySingletonClass();
    private String baseURL = "http://baitussalam.org/";
    private String baseWebserviceURL = "bs/app/bayan.php";

    public static MySingletonClass getInstance() {
        return ourInstance;
    }

    private MySingletonClass() {
    }

    public String getBaseURL() {
        return baseURL;
    }

    public String getBaseWebserviceURL() {
        return baseWebserviceURL;
    }
}
