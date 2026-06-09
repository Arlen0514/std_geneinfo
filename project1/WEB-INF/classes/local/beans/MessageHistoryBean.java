/**
 * MessageHistoryBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2024/02/05 09:59:02
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'message_history'.
 */
public final class MessageHistoryBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "message_history";

    // Fields variable definition.
    private String mh_id         = "";
    private String mh_sendid     = "";
    private String mh_status     = "";
    private String mh_cellphone  = "";
    private String mh_senddate   = "";
    private String mh_content    = "";
    private String mh_memo       = "";
    private String mh_code       = "";
    private String mh_createdate = "";
    private String mh_createuser = "";
    private String mh_modifydate = "";
    private String mh_modifyuser = "";

    // Default constructor.
    public MessageHistoryBean() {}

    // Setters definitions
    public void setMh_id(String mh_id) {
        this.mh_id = mh_id;
    }

    public void setMh_sendid(String mh_sendid) {
        this.mh_sendid = mh_sendid;
    }

    public void setMh_status(String mh_status) {
        this.mh_status = mh_status;
    }

    public void setMh_cellphone(String mh_cellphone) {
        this.mh_cellphone = mh_cellphone;
    }

    public void setMh_senddate(String mh_senddate) {
        this.mh_senddate = mh_senddate;
    }

    public void setMh_content(String mh_content) {
        this.mh_content = mh_content;
    }

    public void setMh_memo(String mh_memo) {
        this.mh_memo = mh_memo;
    }

    public void setMh_code(String mh_code) {
        this.mh_code = mh_code;
    }

    public void setMh_createdate(String mh_createdate) {
        this.mh_createdate = mh_createdate;
    }

    public void setMh_createuser(String mh_createuser) {
        this.mh_createuser = mh_createuser;
    }

    public void setMh_modifydate(String mh_modifydate) {
        this.mh_modifydate = mh_modifydate;
    }

    public void setMh_modifyuser(String mh_modifyuser) {
        this.mh_modifyuser = mh_modifyuser;
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
        vc.add(mh_id);
        vc.add(mh_sendid);
        vc.add(mh_status);
        vc.add(mh_cellphone);
        vc.add(mh_senddate);
        vc.add(mh_content);
        vc.add(mh_memo);
        vc.add(mh_code);
        vc.add(mh_createdate);
        vc.add(mh_createuser);
        vc.add(mh_modifydate);
        vc.add(mh_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getMh_id() {
        return mh_id;
    }

    public String getMh_sendid() {
        return mh_sendid;
    }

    public String getMh_status() {
        return mh_status;
    }

    public String getMh_cellphone() {
        return mh_cellphone;
    }

    public String getMh_senddate() {
        return mh_senddate;
    }

    public String getMh_content() {
        return mh_content;
    }

    public String getMh_memo() {
        return mh_memo;
    }

    public String getMh_code() {
        return mh_code;
    }

    public String getMh_createdate() {
        return mh_createdate;
    }

    public String getMh_createuser() {
        return mh_createuser;
    }

    public String getMh_modifydate() {
        return mh_modifydate;
    }

    public String getMh_modifyuser() {
        return mh_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "mh_id", "mh_sendid", "mh_status", "mh_cellphone", 
        "mh_senddate", "mh_content", "mh_memo", "mh_code", 
        "mh_createdate", "mh_createuser", "mh_modifydate", "mh_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String" };
}
