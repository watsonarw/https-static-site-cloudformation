# https-static-site-cloudformation
Cloudformation template for provisioning everything needed for a HTTPS static site

## What

This repository contains a [Cloudformation] template and a script for provisioning:

* [AWS::S3::Bucket]
* [AWS::S3:BucketPolicy]
* [AWS::CertificateManager::Certificate]
* [AWS::CloudFront::Distribution]
* [AWS::Route53::HostedZone]
* [AWS::Route53::RecordSetGroup]

It can be used to provision a Cloudformation stack which serves a static site from a custom domain with HTTPS.

For more details on what is this script is, you can read [the blog post I wrote about it](https://watsonarw.com/2017/04/04/https-static-site-hosting-in-s3.html)

## How
### Synopsis

```sh
./provision <root-domain-name> [<custom-bucket-name>]
```


### Prerequisites

- You'll need the [aws-cli] installed to run the provision script.
- You'll need access to the AWS console to validate the TLS certificate.

### Usage

**Note: You'll have to do some manual steps in the AWS console while the certificate is provisioning**

1) **Run the provision script with the domain name you're using for your static site.**
   - For example, the domain name you're using is `example.com`, run `./provision "example.com"`
   - _Note: To see more detailed usage instructions, run `./provision` with no arugments_
2) **Point Your DNS at the Route53 Name Servers**
   1) While the stack is being created, open up the AWS console and go to Route53
   2) Find the Hosted Zone that has been created by the script, and find the `NS` type record in the hosted zone - these are your nameservers
   3) Tell your domain registrar to use these name servers for your URL (this is usually done from within your domain registrar's portal)
3) **Verify domain ownership for the the TLS certificate**
   1) In the AWS console and go to the `Certificate Manager` service
   2) Identify the new certificate that is being provisioned by Cloudformation (the status should be `Pending validation`), and expand the section
   3) In the `Domains` section, you should be able to click the `Create records in Route53` button.
   4) It can take some time for the DNS record to propogate, but the Certificate should now be able to verify the domain.
4) **Wait for the script to finish (it might take a while).**


[Cloudformation]: https://aws.amazon.com/cloudformation/
[AWS::S3::Bucket]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket.html
[AWS::S3:BucketPolicy]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-policy.html
[AWS::CertificateManager::Certificate]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-certificatemanager-certificate.html
[AWS::CloudFront::Distribution]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distribution.html
[AWS::Route53::HostedZone]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-route53-hostedzone.html
[AWS::Route53::RecordSetGroup]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-route53-recordsetgroup.html
[aws-cli]: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html
