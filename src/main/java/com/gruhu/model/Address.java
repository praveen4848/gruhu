package com.gruhu.model;

import java.io.Serializable;

public class Address implements Serializable {

    private static final long serialVersionUID = 1L;

    private int addressId;
    private int customerId;
    private String receiverName;
    private String phone;
    private String houseAddress;
    private String city;
    private String state;
    private String pincode;
    private String addressType = "HOME";
    private boolean isDefault;

    public Address() {
    }

    public Address(int addressId, int customerId, String receiverName, String phone,
                   String houseAddress, String city, String state, String pincode,
                   String addressType, boolean isDefault) {
        this.addressId = addressId;
        this.customerId = customerId;
        this.receiverName = receiverName;
        this.phone = phone;
        this.houseAddress = houseAddress;
        this.city = city;
        this.state = state;
        this.pincode = pincode;
        this.addressType = addressType;
        this.isDefault = isDefault;
    }

    public int getAddressId() {
        return addressId;
    }

    public void setAddressId(int addressId) {
        this.addressId = addressId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getHouseAddress() {
        return houseAddress;
    }

    public void setHouseAddress(String houseAddress) {
        this.houseAddress = houseAddress;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getPincode() {
        return pincode;
    }

    public void setPincode(String pincode) {
        this.pincode = pincode;
    }

    public String getAddressType() {
        return addressType;
    }

    public void setAddressType(String addressType) {
        this.addressType = addressType;
    }

    public boolean isDefault() {
        return isDefault;
    }

    public void setDefault(boolean aDefault) {
        isDefault = aDefault;
    }

    public String getFormattedAddress() {
        return String.format("%s, %s, %s - %s", houseAddress, city, state, pincode);
    }

    @Override
    public String toString() {
        return "Address{" +
                "addressId=" + addressId +
                ", receiverName='" + receiverName + '\'' +
                ", city='" + city + '\'' +
                ", pincode='" + pincode + '\'' +
                '}';
    }
}
