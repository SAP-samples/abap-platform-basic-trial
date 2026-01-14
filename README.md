# How to work with the SAP BTP ABAP Environment Basic Trial workbook in customer system landscapes
<!-- Please include descriptive title -->

<!--- Register repository https://api.reuse.software/register, then add REUSE badge:
[![REUSE status](https://api.reuse.software/badge/github.com/SAP-samples/REPO-NAME)](https://api.reuse.software/info/github.com/SAP-samples/REPO-NAME)
-->

## Description
Customers and partners have requested to run the Basic Trial workbook about **Fusion Development with ABAP Cloud in SAP Build** in their own system landscape. So this repository contains a script that has been adapted including the steps that have to be performed by system administrators at customer site in order to fulfill the requirements that are needed in order to go through this work (setup of a SAP BTP ABAP Environment, connection to a SAP S/4HANA demo / test system, ...).   

## Requirements

In order to run this workshop in your own system landscape certain prerequisites have to be fullfilled by your system administrators, that are described in the following.  

If these are fullfilled you can start working on the exercises described below.

<details>   
<summary>Read more ...(for admin's only 😉) </summary> 

1. You have to setup a SAP BTP ABAP Environment in an existing or a new sub account of your SAP BTP Global Account. 
2. The subaccount has to be connected via the SAP Cloud Connector with your on-premise SAP S/4HANA System.  
3. In the SAP BTP ABAP Environment System you have to create a communication arrangement that facilitates the connectivity between the ABAP Cloud stack and your on premise system to build a side-by-side extension

A detailed description of the steps that have to be performed can be found [here](./700_admin_only_configuration_steps/README.md)

</details>

----------


# Exercises

By following the exercices described below you will build a shopping cart app as a side-by-side extension to your SAP S/4HANA system.  

> **Please note**
> As a result of this exercises only Sales Orders will be created.
> In addition there is only read-access to product data.
> It is hence safe to run this exercises in a test / demo system.

## Unit 1 S/4 HANA Extensibility Model and ABAP Cloud

After completing this unit, you will be able to:  

Understand how to build on-stack and side-by-side extensions for SAP S/4HANA Cloud and learn about the ABAP Cloud development model.

[1 Lesson](501_BTP_ABAP-Cloud_Extensibility/README.md)

## Unit 2 - Set up your development environment

After completing this unit, you will be able to:   

Set up the ABAP Development Tools for Eclipse (ADT) and logon to the SAP BTP ABAP Environment system, and create your first ABAP Cloud project

[3 Lessons](502_BTP_ABAP-Cloud_GettingStarted/README.md)

# Unit 3 - Build an application using the ABAP RESTful Application Programming Model (RAP)

After completing this unit, you will be able to:

Create an OData based, transactional UI Service using the ABAP RESTful Application Programming Model as a side-by-side extension on the SAP BTP ABAP environment.

[7 Lessons](503_BTP_ABAP-Cloud_RAP/README.md)

# Unit 4 - Create and deploy an SAP Fiori Application using SAP Build Code

After completing this unit, you will be able to:

Create a new SAP Fiori elements application in SAP Build Code and deploy it to SAP BTP ABAP environment

[3 Lessons](504_BTP_ABAP-Cloud_BAS/README.md)

# Unit 5 - Develop your own APIs to call OData services in SAP S/4HANA Cloud (Optional)

After completing this unit, you will be able to:

Create your own sales order API and product API class to call the OData based API’s in SAP S/4HANA Cloud

[5 Lessons](505_BTP_ABAP-Cloud_OData-Service-Consumption/README.md)

# Unit 6 - Further information

After completing this unit, you will be learn:

how you can further improve your ABAP Cloud skills

[1 Lesson](506_BTP_ABAP-Cloud_Appendix/README.md)


## Download and Installation

See section [Requirements](#requirements) where installation details are described that have to be performed by a system administrator.  

## Known Issues
<!-- You may simply state "No known issues. -->

## How to obtain support
[Create an issue](https://github.com/SAP-samples/<repository-name>/issues) in this repository if you find a bug or have questions about the content.
 
For additional support, [ask a question in SAP Community](https://answers.sap.com/questions/ask.html).

## Contributing
If you wish to contribute code, offer fixes or improvements, please send a pull request. Due to legal reasons, contributors will be asked to accept a DCO when they create the first pull request to this project. This happens in an automated fashion during the submission process. SAP uses [the standard DCO text of the Linux Foundation](https://developercertificate.org/).

## License
Copyright (c) 2025 SAP SE or an SAP affiliate company. All rights reserved. This project is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSE) file.
