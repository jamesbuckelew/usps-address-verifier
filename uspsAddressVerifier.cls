public class uspsAddressVerifier {
    @AuraEnabled(cacheable=true)

    public static String uspsAddressSearch(String urlAddress) {

        if(urlAddress == null)
            return null;

        List<String> addressList = urlAddress.split('/');

        System.debug(addressList);

        XmlStreamWriter w = new XmlStreamWriter();
        
        //      Address 1 is the suite or apt number - APT 221
                w.writeStartElement(null, 'Address1', null);
                w.writeCharacters(addressList[0]);
                w.writeEndElement();
                //Address 2 is actually the first line of the address - 123 Sunset Blvd
                w.writeStartElement(null, 'Address2', null);
                w.writeCharacters(addressList[1]);
                w.writeEndElement();
                w.writeStartElement(null, 'City', null);
                w.writeCharacters(addressList[2]);
                w.writeEndElement();
                w.writeStartElement(null, 'State', null);
                w.writeCharacters(addressList[3]);
                w.writeEndElement();
                w.writeStartElement(null, 'Zip5', null);
                w.writeCharacters(addressList[4]);
                w.writeEndElement();
                w.writeStartElement(null, 'Zip4', null);
                w.writeCharacters(addressList[5]);
                w.writeEndElement();
        
        String xmlOutput = w.getXmlString();
        w.close();

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setMethod('GET');
        req.setEndpoint( 'https://production.shippingapis.com/ShippingAPI.dll?API=Verify&XML=<AddressValidateRequest%20USERID="*********"><Address%20ID="0">' + xmlOutput + '</Address></AddressValidateRequest>');

        
        
        try { 
            res = h.send(req);

        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(res.getBody());
        }

        Dom.Document doc = res.getBodyDocument();
        Dom.XMLNode Address = doc.getRootElement();

        String fullAddressStr;
        System.debug('Cannot just leave this blank!  >>  ' + addressList[0]);

        if (addressList[0] == '') {
            for(Dom.XMLNode children : Address.getChildren()) {

                String line2 = children.getChildElement('Address2', null).getText();
                String City = children.getChildElement('City', null).getText();
                String State = children.getChildElement('State', null).getText();
                String Zip5 = children.getChildElement('Zip5', null).getText();
                String Zip4 = children.getChildElement('Zip4', null).getText();
    
                fullAddressStr = line2 + ' ' + City + ', ' + State + ' ' + Zip5 + '-' + Zip4;
            }

        } else {

            for(Dom.XMLNode children : Address.getChildren()) {

                String line1 = children.getChildElement('Address1', null).getText();
                String line2 = children.getChildElement('Address2', null).getText();
                String City = children.getChildElement('City', null).getText();
                String State = children.getChildElement('State', null).getText();
                String Zip5 = children.getChildElement('Zip5', null).getText();
                String Zip4 = children.getChildElement('Zip4', null).getText();
    
                fullAddressStr = line2 + ' ' + line1 + ' ' + City + ', ' + State + ' ' + Zip5 + '-' + Zip4;
            
            }
        }

    
        return fullAddressStr;

    }

}
