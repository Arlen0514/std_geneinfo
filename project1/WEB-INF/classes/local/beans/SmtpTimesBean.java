/**
 * SmtpTimesBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2024/08/28 17:30:38
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'smtp_times'.
 */
public final class SmtpTimesBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "smtp_times";

    // Fields variable definition.
    private String st_id               = "";
    private String st_hostname         = "";
    private String st_status           = "";
    private int    st_times            = 0;
    private int    st_send_times       = 0;
    private String st_authport         = "";
    private String st_authstatus       = "";
    private String st_ssluse           = "";
    private String st_authaccount      = "";
    private String st_authpassword     = "";
    private String st_serviceemailname = "";
    private String st_serviceemail     = "";
    private int    st_showseq          = 0;
    private String st_code             = "";
    private String st_lang             = "";
    private String st_createdate       = "";
    private String st_createuser       = "";
    private String st_modifydate       = "";
    private String st_modifyuser       = "";

    // Default constructor.
    public SmtpTimesBean() {}

    // Setters definitions
    public void setSt_id(String st_id) {
        this.st_id = st_id;
    }

    public void setSt_hostname(String st_hostname) {
        this.st_hostname = st_hostname;
    }

    public void setSt_status(String st_status) {
        this.st_status = st_status;
    }

    public void setSt_times(int st_times) {
        this.st_times = st_times;
    }

    public void setSt_send_times(int st_send_times) {
        this.st_send_times = st_send_times;
    }

    public void setSt_authport(String st_authport) {
        this.st_authport = st_authport;
    }

    public void setSt_authstatus(String st_authstatus) {
        this.st_authstatus = st_authstatus;
    }

    public void setSt_ssluse(String st_ssluse) {
        this.st_ssluse = st_ssluse;
    }

    public void setSt_authaccount(String st_authaccount) {
        this.st_authaccount = st_authaccount;
    }

    public void setSt_authpassword(String st_authpassword) {
        this.st_authpassword = st_authpassword;
    }

    public void setSt_serviceemailname(String st_serviceemailname) {
        this.st_serviceemailname = st_serviceemailname;
    }

    public void setSt_serviceemail(String st_serviceemail) {
        this.st_serviceemail = st_serviceemail;
    }

    public void setSt_showseq(int st_showseq) {
        this.st_showseq = st_showseq;
    }

    public void setSt_code(String st_code) {
        this.st_code = st_code;
    }

    public void setSt_lang(String st_lang) {
        this.st_lang = st_lang;
    }

    public void setSt_createdate(String st_createdate) {
        this.st_createdate = st_createdate;
    }

    public void setSt_createuser(String st_createuser) {
        this.st_createuser = st_createuser;
    }

    public void setSt_modifydate(String st_modifydate) {
        this.st_modifydate = st_modifydate;
    }

    public void setSt_modifyuser(String st_modifyuser) {
        this.st_modifyuser = st_modifyuser;
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
        vc.add(st_id);
        vc.add(st_hostname);
        vc.add(st_status);
        vc.add(new Integer(st_times));
        vc.add(new Integer(st_send_times));
        vc.add(st_authport);
        vc.add(st_authstatus);
        vc.add(st_ssluse);
        vc.add(st_authaccount);
        vc.add(st_authpassword);
        vc.add(st_serviceemailname);
        vc.add(st_serviceemail);
        vc.add(new Integer(st_showseq));
        vc.add(st_code);
        vc.add(st_lang);
        vc.add(st_createdate);
        vc.add(st_createuser);
        vc.add(st_modifydate);
        vc.add(st_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getSt_id() {
        return st_id;
    }

    public String getSt_hostname() {
        return st_hostname;
    }

    public String getSt_status() {
        return st_status;
    }

    public int getSt_times() {
        return st_times;
    }

    public int getSt_send_times() {
        return st_send_times;
    }

    public String getSt_authport() {
        return st_authport;
    }

    public String getSt_authstatus() {
        return st_authstatus;
    }

    public String getSt_ssluse() {
        return st_ssluse;
    }

    public String getSt_authaccount() {
        return st_authaccount;
    }

    public String getSt_authpassword() {
        return st_authpassword;
    }

    public String getSt_serviceemailname() {
        return st_serviceemailname;
    }

    public String getSt_serviceemail() {
        return st_serviceemail;
    }

    public int getSt_showseq() {
        return st_showseq;
    }

    public String getSt_code() {
        return st_code;
    }

    public String getSt_lang() {
        return st_lang;
    }

    public String getSt_createdate() {
        return st_createdate;
    }

    public String getSt_createuser() {
        return st_createuser;
    }

    public String getSt_modifydate() {
        return st_modifydate;
    }

    public String getSt_modifyuser() {
        return st_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "st_id", "st_hostname", "st_status", "st_times", 
        "st_send_times", "st_authport", "st_authstatus", "st_ssluse", 
        "st_authaccount", "st_authpassword", "st_serviceemailname", "st_serviceemail", 
        "st_showseq", "st_code", "st_lang", "st_createdate", 
        "st_createuser", "st_modifydate", "st_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "int", "int", "String", "String", 
        "String", "String", "String", "String", "String", "int", "String", 
        "String", "String", "String", "String", "String" };
}
