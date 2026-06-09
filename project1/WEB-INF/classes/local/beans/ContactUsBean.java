/**
 * ContactUsBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2024/02/05 09:59:02
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'contact_us'.
 */
public final class ContactUsBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "contact_us";

    // Fields variable definition.
    private String cu_id         = "";
    private String cu_name       = "";
    private String cu_phone      = "";
    private String cu_email      = "";
    private String cu_company    = "";
    private String cu_country    = "";
    private String cu_category   = "";
    private String cu_title      = "";
    private String cu_content    = "";
    private String cu_reply      = "";
    private String cu_code       = "";
    private String cu_lang       = "";
    private String cu_createdate = "";
    private String cu_createuser = "";
    private String cu_modifydate = "";
    private String cu_modifyuser = "";

    // Default constructor.
    public ContactUsBean() {}

    // Setters definitions
    public void setCu_id(String cu_id) {
        this.cu_id = cu_id;
    }

    public void setCu_name(String cu_name) {
        this.cu_name = cu_name;
    }

    public void setCu_phone(String cu_phone) {
        this.cu_phone = cu_phone;
    }

    public void setCu_email(String cu_email) {
        this.cu_email = cu_email;
    }

    public void setCu_company(String cu_company) {
        this.cu_company = cu_company;
    }

    public void setCu_country(String cu_country) {
        this.cu_country = cu_country;
    }

    public void setCu_category(String cu_category) {
        this.cu_category = cu_category;
    }

    public void setCu_title(String cu_title) {
        this.cu_title = cu_title;
    }

    public void setCu_content(String cu_content) {
        this.cu_content = cu_content;
    }

    public void setCu_reply(String cu_reply) {
        this.cu_reply = cu_reply;
    }

    public void setCu_code(String cu_code) {
        this.cu_code = cu_code;
    }

    public void setCu_lang(String cu_lang) {
        this.cu_lang = cu_lang;
    }

    public void setCu_createdate(String cu_createdate) {
        this.cu_createdate = cu_createdate;
    }

    public void setCu_createuser(String cu_createuser) {
        this.cu_createuser = cu_createuser;
    }

    public void setCu_modifydate(String cu_modifydate) {
        this.cu_modifydate = cu_modifydate;
    }

    public void setCu_modifyuser(String cu_modifyuser) {
        this.cu_modifyuser = cu_modifyuser;
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
        vc.add(cu_id);
        vc.add(cu_name);
        vc.add(cu_phone);
        vc.add(cu_email);
        vc.add(cu_company);
        vc.add(cu_country);
        vc.add(cu_category);
        vc.add(cu_title);
        vc.add(cu_content);
        vc.add(cu_reply);
        vc.add(cu_code);
        vc.add(cu_lang);
        vc.add(cu_createdate);
        vc.add(cu_createuser);
        vc.add(cu_modifydate);
        vc.add(cu_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getCu_id() {
        return cu_id;
    }

    public String getCu_name() {
        return cu_name;
    }

    public String getCu_phone() {
        return cu_phone;
    }

    public String getCu_email() {
        return cu_email;
    }

    public String getCu_company() {
        return cu_company;
    }

    public String getCu_country() {
        return cu_country;
    }

    public String getCu_category() {
        return cu_category;
    }

    public String getCu_title() {
        return cu_title;
    }

    public String getCu_content() {
        return cu_content;
    }

    public String getCu_reply() {
        return cu_reply;
    }

    public String getCu_code() {
        return cu_code;
    }

    public String getCu_lang() {
        return cu_lang;
    }

    public String getCu_createdate() {
        return cu_createdate;
    }

    public String getCu_createuser() {
        return cu_createuser;
    }

    public String getCu_modifydate() {
        return cu_modifydate;
    }

    public String getCu_modifyuser() {
        return cu_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "cu_id", "cu_name", "cu_phone", "cu_email", 
        "cu_company", "cu_country", "cu_category", "cu_title", 
        "cu_content", "cu_reply", "cu_code", "cu_lang", 
        "cu_createdate", "cu_createuser", "cu_modifydate", "cu_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String" };
}
