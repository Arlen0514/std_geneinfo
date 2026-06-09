/**
 * LangSetupBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2026/02/24 09:49:21
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'lang_setup'.
 */
public final class LangSetupBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "lang_setup";

    // Fields variable definition.
    private String ls_id         = "";
    private String ls_title      = "";
    private String ls_keyword    = "";
    private String ls_value      = "";
    private String ls_text       = "";
    private String ls_createdate = "";
    private String ls_createuser = "";
    private String ls_modifydate = "";
    private String ls_modifyuser = "";

    // Default constructor.
    public LangSetupBean() {}

    // Setters definitions
    public void setLs_id(String ls_id) {
        this.ls_id = ls_id;
    }

    public void setLs_title(String ls_title) {
        this.ls_title = ls_title;
    }

    public void setLs_keyword(String ls_keyword) {
        this.ls_keyword = ls_keyword;
    }

    public void setLs_value(String ls_value) {
        this.ls_value = ls_value;
    }

    public void setLs_text(String ls_text) {
        this.ls_text = ls_text;
    }

    public void setLs_createdate(String ls_createdate) {
        this.ls_createdate = ls_createdate;
    }

    public void setLs_createuser(String ls_createuser) {
        this.ls_createuser = ls_createuser;
    }

    public void setLs_modifydate(String ls_modifydate) {
        this.ls_modifydate = ls_modifydate;
    }

    public void setLs_modifyuser(String ls_modifyuser) {
        this.ls_modifyuser = ls_modifyuser;
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
        vc.add(ls_id);
        vc.add(ls_title);
        vc.add(ls_keyword);
        vc.add(ls_value);
        vc.add(ls_text);
        vc.add(ls_createdate);
        vc.add(ls_createuser);
        vc.add(ls_modifydate);
        vc.add(ls_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getLs_id() {
        return ls_id;
    }

    public String getLs_title() {
        return ls_title;
    }

    public String getLs_keyword() {
        return ls_keyword;
    }

    public String getLs_value() {
        return ls_value;
    }

    public String getLs_text() {
        return ls_text;
    }

    public String getLs_createdate() {
        return ls_createdate;
    }

    public String getLs_createuser() {
        return ls_createuser;
    }

    public String getLs_modifydate() {
        return ls_modifydate;
    }

    public String getLs_modifyuser() {
        return ls_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "ls_id", "ls_title", "ls_keyword", "ls_value", 
        "ls_text", "ls_createdate", "ls_createuser", "ls_modifydate", 
        "ls_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String" };
}
