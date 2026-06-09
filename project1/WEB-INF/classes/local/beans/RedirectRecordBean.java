/**
 * RedirectRecordBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2024/02/05 09:59:02
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'redirect_record'.
 */
public final class RedirectRecordBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "redirect_record";

    // Fields variable definition.
    private String rr_id         = "";
    private String rr_title      = "";
    private String rr_url        = "";
    private String rr_code       = "";
    private String rr_createdate = "";
    private String rr_createuser = "";
    private String rr_modifydate = "";
    private String rr_modifyuser = "";

    // Default constructor.
    public RedirectRecordBean() {}

    // Setters definitions
    public void setRr_id(String rr_id) {
        this.rr_id = rr_id;
    }

    public void setRr_title(String rr_title) {
        this.rr_title = rr_title;
    }

    public void setRr_url(String rr_url) {
        this.rr_url = rr_url;
    }

    public void setRr_code(String rr_code) {
        this.rr_code = rr_code;
    }

    public void setRr_createdate(String rr_createdate) {
        this.rr_createdate = rr_createdate;
    }

    public void setRr_createuser(String rr_createuser) {
        this.rr_createuser = rr_createuser;
    }

    public void setRr_modifydate(String rr_modifydate) {
        this.rr_modifydate = rr_modifydate;
    }

    public void setRr_modifyuser(String rr_modifyuser) {
        this.rr_modifyuser = rr_modifyuser;
    }

    // Convert the fields name, type, value into a Vector.
    public Vector beanContent() {
        Vector content = new Vector();
        // Field names.
        content.add(_fnames);
        // Field java types.
        content.add(_ftypes);
        // Field values.
        Vector vc = new Vector();
        vc.add(rr_id);
        vc.add(rr_title);
        vc.add(rr_url);
        vc.add(rr_code);
        vc.add(rr_createdate);
        vc.add(rr_createuser);
        vc.add(rr_modifydate);
        vc.add(rr_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getRr_id() {
        return rr_id;
    }

    public String getRr_title() {
        return rr_title;
    }

    public String getRr_url() {
        return rr_url;
    }

    public String getRr_code() {
        return rr_code;
    }

    public String getRr_createdate() {
        return rr_createdate;
    }

    public String getRr_createuser() {
        return rr_createuser;
    }

    public String getRr_modifydate() {
        return rr_modifydate;
    }

    public String getRr_modifyuser() {
        return rr_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "rr_id", "rr_title", "rr_url", "rr_code", 
        "rr_createdate", "rr_createuser", "rr_modifydate", "rr_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String" };
}
