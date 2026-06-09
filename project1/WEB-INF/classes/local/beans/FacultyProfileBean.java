/**
 * FacultyProfileBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2024/02/05 09:59:02
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'faculty_profile'.
 */
public final class FacultyProfileBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "faculty_profile";

    // Fields variable definition.
    private String fp_id             = "";
    private String fp_upcategory     = "";
    private String fp_category       = "";
    private String fp_title          = "";
    private String fp_subtitle       = "";
    private String fp_account        = "";
    private String fp_password       = "";
    private String fp_tag            = "";
    private String fp_desc           = "";
    private String fp_content        = "";
    private String fp_content_title1 = "";
    private String fp_content1       = "";
    private String fp_content_title2 = "";
    private String fp_content2       = "";
    private String fp_phone          = "";
    private String fp_cellphone      = "";
    private String fp_fax            = "";
    private String fp_email          = "";
    private String fp_job            = "";
    private String fp_expertise      = "";
    private String fp_course         = "";
    private String fp_image          = "";
    private String fp_url            = "";
    private String fp_display        = "";
    private int    fp_showseq        = 0;
    private String fp_emitdate       = "";
    private String fp_restdate       = "";
    private String fp_lang           = "";
    private String fp_code           = "";
    private String fp_webtitle       = "";
    private String fp_robots         = "";
    private String fp_revisit_after  = "";
    private String fp_keywords       = "";
    private String fp_description    = "";
    private String fp_copyright      = "";
    private String fp_seo_head_track = "";
    private String fp_seo_body_track = "";
    private String fp_createdate     = "";
    private String fp_createuser     = "";
    private String fp_modifydate     = "";
    private String fp_modifyuser     = "";

    // Default constructor.
    public FacultyProfileBean() {}

    // Setters definitions
    public void setFp_id(String fp_id) {
        this.fp_id = fp_id;
    }

    public void setFp_upcategory(String fp_upcategory) {
        this.fp_upcategory = fp_upcategory;
    }

    public void setFp_category(String fp_category) {
        this.fp_category = fp_category;
    }

    public void setFp_title(String fp_title) {
        this.fp_title = fp_title;
    }

    public void setFp_subtitle(String fp_subtitle) {
        this.fp_subtitle = fp_subtitle;
    }

    public void setFp_account(String fp_account) {
        this.fp_account = fp_account;
    }

    public void setFp_password(String fp_password) {
        this.fp_password = fp_password;
    }

    public void setFp_tag(String fp_tag) {
        this.fp_tag = fp_tag;
    }

    public void setFp_desc(String fp_desc) {
        this.fp_desc = fp_desc;
    }

    public void setFp_content(String fp_content) {
        this.fp_content = fp_content;
    }

    public void setFp_content_title1(String fp_content_title1) {
        this.fp_content_title1 = fp_content_title1;
    }

    public void setFp_content1(String fp_content1) {
        this.fp_content1 = fp_content1;
    }

    public void setFp_content_title2(String fp_content_title2) {
        this.fp_content_title2 = fp_content_title2;
    }

    public void setFp_content2(String fp_content2) {
        this.fp_content2 = fp_content2;
    }

    public void setFp_phone(String fp_phone) {
        this.fp_phone = fp_phone;
    }

    public void setFp_cellphone(String fp_cellphone) {
        this.fp_cellphone = fp_cellphone;
    }

    public void setFp_fax(String fp_fax) {
        this.fp_fax = fp_fax;
    }

    public void setFp_email(String fp_email) {
        this.fp_email = fp_email;
    }

    public void setFp_job(String fp_job) {
        this.fp_job = fp_job;
    }

    public void setFp_expertise(String fp_expertise) {
        this.fp_expertise = fp_expertise;
    }

    public void setFp_course(String fp_course) {
        this.fp_course = fp_course;
    }

    public void setFp_image(String fp_image) {
        this.fp_image = fp_image;
    }

    public void setFp_url(String fp_url) {
        this.fp_url = fp_url;
    }

    public void setFp_display(String fp_display) {
        this.fp_display = fp_display;
    }

    public void setFp_showseq(int fp_showseq) {
        this.fp_showseq = fp_showseq;
    }

    public void setFp_emitdate(String fp_emitdate) {
        this.fp_emitdate = fp_emitdate;
    }

    public void setFp_restdate(String fp_restdate) {
        this.fp_restdate = fp_restdate;
    }

    public void setFp_lang(String fp_lang) {
        this.fp_lang = fp_lang;
    }

    public void setFp_code(String fp_code) {
        this.fp_code = fp_code;
    }

    public void setFp_webtitle(String fp_webtitle) {
        this.fp_webtitle = fp_webtitle;
    }

    public void setFp_robots(String fp_robots) {
        this.fp_robots = fp_robots;
    }

    public void setFp_revisit_after(String fp_revisit_after) {
        this.fp_revisit_after = fp_revisit_after;
    }

    public void setFp_keywords(String fp_keywords) {
        this.fp_keywords = fp_keywords;
    }

    public void setFp_description(String fp_description) {
        this.fp_description = fp_description;
    }

    public void setFp_copyright(String fp_copyright) {
        this.fp_copyright = fp_copyright;
    }

    public void setFp_seo_head_track(String fp_seo_head_track) {
        this.fp_seo_head_track = fp_seo_head_track;
    }

    public void setFp_seo_body_track(String fp_seo_body_track) {
        this.fp_seo_body_track = fp_seo_body_track;
    }

    public void setFp_createdate(String fp_createdate) {
        this.fp_createdate = fp_createdate;
    }

    public void setFp_createuser(String fp_createuser) {
        this.fp_createuser = fp_createuser;
    }

    public void setFp_modifydate(String fp_modifydate) {
        this.fp_modifydate = fp_modifydate;
    }

    public void setFp_modifyuser(String fp_modifyuser) {
        this.fp_modifyuser = fp_modifyuser;
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
        vc.add(fp_id);
        vc.add(fp_upcategory);
        vc.add(fp_category);
        vc.add(fp_title);
        vc.add(fp_subtitle);
        vc.add(fp_account);
        vc.add(fp_password);
        vc.add(fp_tag);
        vc.add(fp_desc);
        vc.add(fp_content);
        vc.add(fp_content_title1);
        vc.add(fp_content1);
        vc.add(fp_content_title2);
        vc.add(fp_content2);
        vc.add(fp_phone);
        vc.add(fp_cellphone);
        vc.add(fp_fax);
        vc.add(fp_email);
        vc.add(fp_job);
        vc.add(fp_expertise);
        vc.add(fp_course);
        vc.add(fp_image);
        vc.add(fp_url);
        vc.add(fp_display);
        vc.add(new Integer(fp_showseq));
        vc.add(fp_emitdate);
        vc.add(fp_restdate);
        vc.add(fp_lang);
        vc.add(fp_code);
        vc.add(fp_webtitle);
        vc.add(fp_robots);
        vc.add(fp_revisit_after);
        vc.add(fp_keywords);
        vc.add(fp_description);
        vc.add(fp_copyright);
        vc.add(fp_seo_head_track);
        vc.add(fp_seo_body_track);
        vc.add(fp_createdate);
        vc.add(fp_createuser);
        vc.add(fp_modifydate);
        vc.add(fp_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getFp_id() {
        return fp_id;
    }

    public String getFp_upcategory() {
        return fp_upcategory;
    }

    public String getFp_category() {
        return fp_category;
    }

    public String getFp_title() {
        return fp_title;
    }

    public String getFp_subtitle() {
        return fp_subtitle;
    }

    public String getFp_account() {
        return fp_account;
    }

    public String getFp_password() {
        return fp_password;
    }

    public String getFp_tag() {
        return fp_tag;
    }

    public String getFp_desc() {
        return fp_desc;
    }

    public String getFp_content() {
        return fp_content;
    }

    public String getFp_content_title1() {
        return fp_content_title1;
    }

    public String getFp_content1() {
        return fp_content1;
    }

    public String getFp_content_title2() {
        return fp_content_title2;
    }

    public String getFp_content2() {
        return fp_content2;
    }

    public String getFp_phone() {
        return fp_phone;
    }

    public String getFp_cellphone() {
        return fp_cellphone;
    }

    public String getFp_fax() {
        return fp_fax;
    }

    public String getFp_email() {
        return fp_email;
    }

    public String getFp_job() {
        return fp_job;
    }

    public String getFp_expertise() {
        return fp_expertise;
    }

    public String getFp_course() {
        return fp_course;
    }

    public String getFp_image() {
        return fp_image;
    }

    public String getFp_url() {
        return fp_url;
    }

    public String getFp_display() {
        return fp_display;
    }

    public int getFp_showseq() {
        return fp_showseq;
    }

    public String getFp_emitdate() {
        return fp_emitdate;
    }

    public String getFp_restdate() {
        return fp_restdate;
    }

    public String getFp_lang() {
        return fp_lang;
    }

    public String getFp_code() {
        return fp_code;
    }

    public String getFp_webtitle() {
        return fp_webtitle;
    }

    public String getFp_robots() {
        return fp_robots;
    }

    public String getFp_revisit_after() {
        return fp_revisit_after;
    }

    public String getFp_keywords() {
        return fp_keywords;
    }

    public String getFp_description() {
        return fp_description;
    }

    public String getFp_copyright() {
        return fp_copyright;
    }

    public String getFp_seo_head_track() {
        return fp_seo_head_track;
    }

    public String getFp_seo_body_track() {
        return fp_seo_body_track;
    }

    public String getFp_createdate() {
        return fp_createdate;
    }

    public String getFp_createuser() {
        return fp_createuser;
    }

    public String getFp_modifydate() {
        return fp_modifydate;
    }

    public String getFp_modifyuser() {
        return fp_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "fp_id", "fp_upcategory", "fp_category", "fp_title", 
        "fp_subtitle", "fp_account", "fp_password", "fp_tag", 
        "fp_desc", "fp_content", "fp_content_title1", "fp_content1", 
        "fp_content_title2", "fp_content2", "fp_phone", "fp_cellphone", 
        "fp_fax", "fp_email", "fp_job", "fp_expertise", 
        "fp_course", "fp_image", "fp_url", "fp_display", 
        "fp_showseq", "fp_emitdate", "fp_restdate", "fp_lang", 
        "fp_code", "fp_webtitle", "fp_robots", "fp_revisit_after", 
        "fp_keywords", "fp_description", "fp_copyright", "fp_seo_head_track", 
        "fp_seo_body_track", "fp_createdate", "fp_createuser", "fp_modifydate", 
        "fp_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "int", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String" };
}
