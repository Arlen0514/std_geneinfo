/**
 * StoreProfileBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2024/02/05 09:59:02
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'store_profile'.
 */
public final class StoreProfileBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "store_profile";

    // Fields variable definition.
    private String sp_id             = "";
    private String sp_upcategory     = "";
    private String sp_category       = "";
    private String sp_area           = "";
    private String sp_title          = "";
    private String sp_address        = "";
    private String sp_phone          = "";
    private String sp_fax            = "";
    private String sp_email          = "";
    private String sp_time           = "";
    private String sp_url            = "";
    private String sp_image          = "";
    private String sp_desc           = "";
    private String sp_content        = "";
    private int    sp_showseq        = 0;
    private String sp_emitdate       = "";
    private String sp_restdate       = "";
    private String sp_lang           = "";
    private String sp_code           = "";
    private String sp_webtitle       = "";
    private String sp_robots         = "";
    private String sp_revisit_after  = "";
    private String sp_keywords       = "";
    private String sp_description    = "";
    private String sp_copyright      = "";
    private String sp_seo_head_track = "";
    private String sp_seo_body_track = "";
    private String sp_createdate     = "";
    private String sp_createuser     = "";
    private String sp_modifydate     = "";
    private String sp_modifyuser     = "";

    // Default constructor.
    public StoreProfileBean() {}

    // Setters definitions
    public void setSp_id(String sp_id) {
        this.sp_id = sp_id;
    }

    public void setSp_upcategory(String sp_upcategory) {
        this.sp_upcategory = sp_upcategory;
    }

    public void setSp_category(String sp_category) {
        this.sp_category = sp_category;
    }

    public void setSp_area(String sp_area) {
        this.sp_area = sp_area;
    }

    public void setSp_title(String sp_title) {
        this.sp_title = sp_title;
    }

    public void setSp_address(String sp_address) {
        this.sp_address = sp_address;
    }

    public void setSp_phone(String sp_phone) {
        this.sp_phone = sp_phone;
    }

    public void setSp_fax(String sp_fax) {
        this.sp_fax = sp_fax;
    }

    public void setSp_email(String sp_email) {
        this.sp_email = sp_email;
    }

    public void setSp_time(String sp_time) {
        this.sp_time = sp_time;
    }

    public void setSp_url(String sp_url) {
        this.sp_url = sp_url;
    }

    public void setSp_image(String sp_image) {
        this.sp_image = sp_image;
    }

    public void setSp_desc(String sp_desc) {
        this.sp_desc = sp_desc;
    }

    public void setSp_content(String sp_content) {
        this.sp_content = sp_content;
    }

    public void setSp_showseq(int sp_showseq) {
        this.sp_showseq = sp_showseq;
    }

    public void setSp_emitdate(String sp_emitdate) {
        this.sp_emitdate = sp_emitdate;
    }

    public void setSp_restdate(String sp_restdate) {
        this.sp_restdate = sp_restdate;
    }

    public void setSp_lang(String sp_lang) {
        this.sp_lang = sp_lang;
    }

    public void setSp_code(String sp_code) {
        this.sp_code = sp_code;
    }

    public void setSp_webtitle(String sp_webtitle) {
        this.sp_webtitle = sp_webtitle;
    }

    public void setSp_robots(String sp_robots) {
        this.sp_robots = sp_robots;
    }

    public void setSp_revisit_after(String sp_revisit_after) {
        this.sp_revisit_after = sp_revisit_after;
    }

    public void setSp_keywords(String sp_keywords) {
        this.sp_keywords = sp_keywords;
    }

    public void setSp_description(String sp_description) {
        this.sp_description = sp_description;
    }

    public void setSp_copyright(String sp_copyright) {
        this.sp_copyright = sp_copyright;
    }

    public void setSp_seo_head_track(String sp_seo_head_track) {
        this.sp_seo_head_track = sp_seo_head_track;
    }

    public void setSp_seo_body_track(String sp_seo_body_track) {
        this.sp_seo_body_track = sp_seo_body_track;
    }

    public void setSp_createdate(String sp_createdate) {
        this.sp_createdate = sp_createdate;
    }

    public void setSp_createuser(String sp_createuser) {
        this.sp_createuser = sp_createuser;
    }

    public void setSp_modifydate(String sp_modifydate) {
        this.sp_modifydate = sp_modifydate;
    }

    public void setSp_modifyuser(String sp_modifyuser) {
        this.sp_modifyuser = sp_modifyuser;
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
        vc.add(sp_id);
        vc.add(sp_upcategory);
        vc.add(sp_category);
        vc.add(sp_area);
        vc.add(sp_title);
        vc.add(sp_address);
        vc.add(sp_phone);
        vc.add(sp_fax);
        vc.add(sp_email);
        vc.add(sp_time);
        vc.add(sp_url);
        vc.add(sp_image);
        vc.add(sp_desc);
        vc.add(sp_content);
        vc.add(new Integer(sp_showseq));
        vc.add(sp_emitdate);
        vc.add(sp_restdate);
        vc.add(sp_lang);
        vc.add(sp_code);
        vc.add(sp_webtitle);
        vc.add(sp_robots);
        vc.add(sp_revisit_after);
        vc.add(sp_keywords);
        vc.add(sp_description);
        vc.add(sp_copyright);
        vc.add(sp_seo_head_track);
        vc.add(sp_seo_body_track);
        vc.add(sp_createdate);
        vc.add(sp_createuser);
        vc.add(sp_modifydate);
        vc.add(sp_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getSp_id() {
        return sp_id;
    }

    public String getSp_upcategory() {
        return sp_upcategory;
    }

    public String getSp_category() {
        return sp_category;
    }

    public String getSp_area() {
        return sp_area;
    }

    public String getSp_title() {
        return sp_title;
    }

    public String getSp_address() {
        return sp_address;
    }

    public String getSp_phone() {
        return sp_phone;
    }

    public String getSp_fax() {
        return sp_fax;
    }

    public String getSp_email() {
        return sp_email;
    }

    public String getSp_time() {
        return sp_time;
    }

    public String getSp_url() {
        return sp_url;
    }

    public String getSp_image() {
        return sp_image;
    }

    public String getSp_desc() {
        return sp_desc;
    }

    public String getSp_content() {
        return sp_content;
    }

    public int getSp_showseq() {
        return sp_showseq;
    }

    public String getSp_emitdate() {
        return sp_emitdate;
    }

    public String getSp_restdate() {
        return sp_restdate;
    }

    public String getSp_lang() {
        return sp_lang;
    }

    public String getSp_code() {
        return sp_code;
    }

    public String getSp_webtitle() {
        return sp_webtitle;
    }

    public String getSp_robots() {
        return sp_robots;
    }

    public String getSp_revisit_after() {
        return sp_revisit_after;
    }

    public String getSp_keywords() {
        return sp_keywords;
    }

    public String getSp_description() {
        return sp_description;
    }

    public String getSp_copyright() {
        return sp_copyright;
    }

    public String getSp_seo_head_track() {
        return sp_seo_head_track;
    }

    public String getSp_seo_body_track() {
        return sp_seo_body_track;
    }

    public String getSp_createdate() {
        return sp_createdate;
    }

    public String getSp_createuser() {
        return sp_createuser;
    }

    public String getSp_modifydate() {
        return sp_modifydate;
    }

    public String getSp_modifyuser() {
        return sp_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "sp_id", "sp_upcategory", "sp_category", "sp_area", 
        "sp_title", "sp_address", "sp_phone", "sp_fax", 
        "sp_email", "sp_time", "sp_url", "sp_image", 
        "sp_desc", "sp_content", "sp_showseq", "sp_emitdate", 
        "sp_restdate", "sp_lang", "sp_code", "sp_webtitle", 
        "sp_robots", "sp_revisit_after", "sp_keywords", "sp_description", 
        "sp_copyright", "sp_seo_head_track", "sp_seo_body_track", "sp_createdate", 
        "sp_createuser", "sp_modifydate", "sp_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "int", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String" };
}
