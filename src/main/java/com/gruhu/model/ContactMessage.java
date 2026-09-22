package com.gruhu.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class ContactMessage implements Serializable {

    private static final long serialVersionUID = 1L;

    private int messageId;
    private String name;
    private String email;
    private String phone;
    private String subject;
    private String message;
    private Timestamp sentAt;
    private String status = "NEW";

    public ContactMessage() {
    }

    public ContactMessage(int messageId, String name, String email, String phone,
                          String subject, String message, Timestamp sentAt, String status) {
        this.messageId = messageId;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.subject = subject;
        this.message = message;
        this.sentAt = sentAt;
        this.status = status;
    }

    public int getMessageId() {
        return messageId;
    }

    public void setMessageId(int messageId) {
        this.messageId = messageId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Timestamp getSentAt() {
        return sentAt;
    }

    public void setSentAt(Timestamp sentAt) {
        this.sentAt = sentAt;
    }

    public Timestamp getCreatedAt() {
        return sentAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.sentAt = createdAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "ContactMessage{" +
                "messageId=" + messageId +
                ", name='" + name + '\'' +
                ", subject='" + subject + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
