xmlport 70000 "MyTaxi CRM Records Exp/Import"
{
    FormatEvaluate = Xml;

    schema
    {
        textelement(Root)
        {
            tableelement("MyTaxi CRM Interface Records"; "MyTaxi CRM Interface Records")
            {
                XmlName = 'MyTaxiRecords';
                fieldelement(a; "MyTaxi CRM Interface Records"."Entry No.")
                {
                }
                fieldelement(z; "MyTaxi CRM Interface Records"."Interface Type")
                {
                }
                fieldelement(e; "MyTaxi CRM Interface Records".company)
                {
                }
                fieldelement(r; "MyTaxi CRM Interface Records".id)
                {
                }
                fieldelement(t; "MyTaxi CRM Interface Records".number)
                {
                }
                fieldelement(y; "MyTaxi CRM Interface Records".name)
                {
                }
                fieldelement(u; "MyTaxi CRM Interface Records".orgNo)
                {
                }
                fieldelement(i; "MyTaxi CRM Interface Records".address1)
                {
                }
                fieldelement(o; "MyTaxi CRM Interface Records".city)
                {
                }
                fieldelement(p; "MyTaxi CRM Interface Records".zip)
                {
                }
                fieldelement(q; "MyTaxi CRM Interface Records".country)
                {
                }
                fieldelement(s; "MyTaxi CRM Interface Records".tele1)
                {
                }
                fieldelement(d; "MyTaxi CRM Interface Records".email)
                {
                }
                fieldelement(f; "MyTaxi CRM Interface Records".contact)
                {
                }
                fieldelement(g; "MyTaxi CRM Interface Records".vatNo)
                {
                }
                fieldelement(h; "MyTaxi CRM Interface Records".statusCode)
                {
                }
                fieldelement(j; "MyTaxi CRM Interface Records".dateStatusChanged)
                {
                }
                fieldelement(k; "MyTaxi CRM Interface Records".additionalInformation)
                {
                }
                fieldelement(l; "MyTaxi CRM Interface Records".invoiceid)
                {
                }
                fieldelement(m; "MyTaxi CRM Interface Records".externalReference)
                {
                }
                fieldelement(w; "MyTaxi CRM Interface Records".invoiceType)
                {
                }
                fieldelement(x; "MyTaxi CRM Interface Records".idCustomer)
                {
                }
                fieldelement(c; "MyTaxi CRM Interface Records".dateInvoice)
                {
                }
                fieldelement(v; "MyTaxi CRM Interface Records".dueDate)
                {
                }
                fieldelement(b; "MyTaxi CRM Interface Records".countryCode)
                {
                }
                fieldelement(n; "MyTaxi CRM Interface Records".currency)
                {
                }
                fieldelement(aa; "MyTaxi CRM Interface Records".sumNetValue)
                {
                }
                fieldelement(az; "MyTaxi CRM Interface Records".sumTaxValue)
                {
                }
                fieldelement(ar; "MyTaxi CRM Interface Records".sumGrossValue)
                {
                }
                fieldelement(at; "MyTaxi CRM Interface Records".discountCommissionNet)
                {
                }
                fieldelement(ay; "MyTaxi CRM Interface Records".discountCommissionTax)
                {
                }
                fieldelement(au; "MyTaxi CRM Interface Records".discountCommissionGross)
                {
                }
                fieldelement(ai; "MyTaxi CRM Interface Records".netCommission)
                {
                }
                fieldelement(ao; "MyTaxi CRM Interface Records".taxCommission)
                {
                }
                fieldelement(ap; "MyTaxi CRM Interface Records".grossCommission)
                {
                }
                fieldelement(aq; "MyTaxi CRM Interface Records".netHotelValue)
                {
                }
                fieldelement(as; "MyTaxi CRM Interface Records".taxHotelValue)
                {
                }
                fieldelement(ad; "MyTaxi CRM Interface Records".grossHotelValue)
                {
                }
                fieldelement(af; "MyTaxi CRM Interface Records".netInvoicingFee)
                {
                }
                fieldelement(ag; "MyTaxi CRM Interface Records".taxInvoicingFee)
                {
                }
                fieldelement(ah; "MyTaxi CRM Interface Records".grossInvoicingFee)
                {
                }
                fieldelement(aj; "MyTaxi CRM Interface Records".netPayment)
                {
                }
                fieldelement(ak; "MyTaxi CRM Interface Records".netPaymentFeeMP)
                {
                }
                fieldelement(al; "MyTaxi CRM Interface Records".taxPaymentFeeMP)
                {
                }
                fieldelement(am; "MyTaxi CRM Interface Records".grossPaymentFeeMP)
                {
                }
                fieldelement(aw; "MyTaxi CRM Interface Records".netPaymentFeeBA)
                {
                }
                fieldelement(ax; "MyTaxi CRM Interface Records".taxPaymentFeeBA)
                {
                }
                fieldelement(ac; "MyTaxi CRM Interface Records".grossPaymentFeeBA)
                {
                }
                tableelement("MyTaxi CRM Interf Sub Records"; "MyTaxi CRM Interf Sub Records")
                {
                    XmlName = 'MyTaxiSubRecords';
                    fieldelement(ze; "MyTaxi CRM Interf Sub Records"."Records Entry No.")
                    {
                    }
                    fieldelement(zr; "MyTaxi CRM Interf Sub Records"."Entry No.")
                    {
                    }
                    fieldelement(zt; "MyTaxi CRM Interf Sub Records".invoiceid)
                    {
                    }
                    fieldelement(zy; "MyTaxi CRM Interf Sub Records".typeOfAdditionalNote)
                    {
                    }
                    fieldelement(zu; "MyTaxi CRM Interf Sub Records".accountNumber)
                    {
                    }
                    fieldelement(zi; "MyTaxi CRM Interf Sub Records".netCredit)
                    {
                    }
                    fieldelement(zo; "MyTaxi CRM Interf Sub Records".taxCredit)
                    {
                    }
                    fieldelement(zp; "MyTaxi CRM Interf Sub Records".grossCredit)
                    {
                    }
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
}

