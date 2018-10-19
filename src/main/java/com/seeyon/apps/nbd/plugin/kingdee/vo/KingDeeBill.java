package com.seeyon.apps.nbd.plugin.kingdee.vo;

import java.util.List;

/**
 * Created by liuwenping on 2018/10/11.
 */
public class KingDeeBill {

    private PayBillType payBillType;
    private String payeeNumber;
    private SettlementType settlementType;
    private Integer exchangeRate;
    private String number;
    private PayerAccount payerAccount;
    private Double localAmt;
    private PayerAccountBank payerAccountBank;
    private CommonKingDeeVo cu;
    private CommonKingDeeVo currency;
    private PayerBank payerBank;
    private String bankNumber;
    private String payeeName;
    private Double amount;
    private CommonKingDeeVo company;
    private List<KingdeeEntry> entries;
    private CommonKingDeeVo payeeType;
    private String bizDate;

    public String getBankNumber() {
        return bankNumber;
    }

    public void setBankNumber(String bankNumber) {
        this.bankNumber = bankNumber;
    }

    public String getPayeeNumber() {
        return payeeNumber;
    }

    public void setPayeeNumber(String payeeNumber) {
        this.payeeNumber = payeeNumber;
    }

    public PayBillType getPayBillType() {
        return payBillType;
    }

    public void setPayBillType(PayBillType payBillType) {
        this.payBillType = payBillType;
    }

    public SettlementType getSettlementType() {
        return settlementType;
    }

    public void setSettlementType(SettlementType settlementType) {
        this.settlementType = settlementType;
    }

    public Integer getExchangeRate() {
        return exchangeRate;
    }

    public void setExchangeRate(Integer exchangeRate) {
        this.exchangeRate = exchangeRate;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public PayerAccount getPayerAccount() {
        return payerAccount;
    }

    public void setPayerAccount(PayerAccount payerAccount) {
        this.payerAccount = payerAccount;
    }


    public PayerAccountBank getPayerAccountBank() {
        return payerAccountBank;
    }

    public Double getLocalAmt() {
        return localAmt;
    }

    public void setLocalAmt(Double localAmt) {
        this.localAmt = localAmt;
    }

    public void setPayerAccountBank(PayerAccountBank payerAccountBank) {
        this.payerAccountBank = payerAccountBank;
    }

    public CommonKingDeeVo getCu() {
        return cu;
    }

    public void setCu(CommonKingDeeVo cu) {
        this.cu = cu;
    }

    public CommonKingDeeVo getCurrency() {
        return currency;
    }

    public void setCurrency(CommonKingDeeVo currency) {
        this.currency = currency;
    }

    public PayerBank getPayerBank() {
        return payerBank;
    }

    public void setPayerBank(PayerBank payerBank) {
        this.payerBank = payerBank;
    }

    public String getPayeeName() {
        return payeeName;
    }

    public void setPayeeName(String payeeName) {
        this.payeeName = payeeName;
    }

    public Double getAmount() {
        return amount;
    }

    public void setAmount(Double amount) {
        this.amount = amount;
    }

    public CommonKingDeeVo getCompany() {
        return company;
    }

    public void setCompany(CommonKingDeeVo company) {
        this.company = company;
    }

    public List<KingdeeEntry> getEntries() {
        return entries;
    }

    public void setEntries(List<KingdeeEntry> entries) {
        this.entries = entries;
    }

    public CommonKingDeeVo getPayeeType() {
        return payeeType;
    }

    public void setPayeeType(CommonKingDeeVo payeeType) {
        this.payeeType = payeeType;
    }

    public String getBizDate() {
        return bizDate;
    }

    public void setBizDate(String bizDate) {
        this.bizDate = bizDate;
    }
}
