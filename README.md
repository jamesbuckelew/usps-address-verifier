# usps-address-verifier
Address Verification via LWC in Salesforce

Lightning Web Component for Salesforce Record Page to send an address through USPS for Address Verification and Zip +4 searching. 

User has 5 fields to fill out, not all are required. The request get's constructed in XML and queried through USPS REST API. It returns an XML response and is parsed through JavaScript and Printed as a String for our employees to copy and paste where it's needed. 
