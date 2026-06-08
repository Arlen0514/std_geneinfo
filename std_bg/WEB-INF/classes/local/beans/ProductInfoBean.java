/**
 * ProductInfoBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2024/02/05 09:59:02
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'product_info'.
 */
public final class ProductInfoBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "product_info";

    // Fields variable definition.
    private String pi_id         = "";
    private String pd_id         = "";
    private String pi_image      = "";
    private String pi_file       = "";
    private String pi_video      = "";
    private String pi_chinavideo = "";
    private String pi_code       = "";
    private int    pi_showseq    = 0;
    private String pi_createdate = "";
    private String pi_createuser = "";
    private String pi_modifydate = "";
    private String pi_modifyuser = "";

    // Default constructor.
    public ProductInfoBean() {}

    // Setters definitions
    public void setPi_id(String pi_id) {
        this.pi_id = pi_id;
    }

    public void setPd_id(String pd_id) {
        this.pd_id = pd_id;
    }

    public void setPi_image(String pi_image) {
        this.pi_image = pi_image;
    }

    public void setPi_file(String pi_file) {
        this.pi_file = pi_file;
    }

    public void setPi_video(String pi_video) {
        this.pi_video = pi_video;
    }

    public void setPi_chinavideo(String pi_chinavideo) {
        this.pi_chinavideo = pi_chinavideo;
    }

    public void setPi_code(String pi_code) {
        this.pi_code = pi_code;
    }

    public void setPi_showseq(int pi_showseq) {
        this.pi_showseq = pi_showseq;
    }

    public void setPi_createdate(String pi_createdate) {
        this.pi_createdate = pi_createdate;
    }

    public void setPi_createuser(String pi_createuser) {
        this.pi_createuser = pi_createuser;
    }

    public void setPi_modifydate(String pi_modifydate) {
        this.pi_modifydate = pi_modifydate;
    }

    public void setPi_modifyuser(String pi_modifyuser) {
        this.pi_modifyuser = pi_modifyuser;
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
        vc.add(pi_id);
        vc.add(pd_id);
        vc.add(pi_image);
        vc.add(pi_file);
        vc.add(pi_video);
        vc.add(pi_chinavideo);
        vc.add(pi_code);
        vc.add(new Integer(pi_showseq));
        vc.add(pi_createdate);
        vc.add(pi_createuser);
        vc.add(pi_modifydate);
        vc.add(pi_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getPi_id() {
        return pi_id;
    }

    public String getPd_id() {
        return pd_id;
    }

    public String getPi_image() {
        return pi_image;
    }

    public String getPi_file() {
        return pi_file;
    }

    public String getPi_video() {
        return pi_video;
    }

    public String getPi_chinavideo() {
        return pi_chinavideo;
    }

    public String getPi_code() {
        return pi_code;
    }

    public int getPi_showseq() {
        return pi_showseq;
    }

    public String getPi_createdate() {
        return pi_createdate;
    }

    public String getPi_createuser() {
        return pi_createuser;
    }

    public String getPi_modifydate() {
        return pi_modifydate;
    }

    public String getPi_modifyuser() {
        return pi_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "pi_id", "pd_id", "pi_image", "pi_file", 
        "pi_video", "pi_chinavideo", "pi_code", "pi_showseq", 
        "pi_createdate", "pi_createuser", "pi_modifydate", "pi_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "int", "String", "String", "String", "String" };
}
