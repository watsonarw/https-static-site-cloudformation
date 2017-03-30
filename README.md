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

It can be used to deploy a Cloudformation stack which serves a static site from a custom domain with HTTPS.

## How

### Prerequisites

You'll need the [aws-cli] installed to run the deploy script.

### Usage

Run the deploy script with the domain name you're using for your static site. For example, the domain name you're using is `example.com`, run:

```sh
./deploy "example.com"
```

[Cloudformation]: https://aws.amazon.com/cloudformation/
[AWS::S3::Bucket]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket.html
[AWS::S3:BucketPolicy]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-policy.html
[AWS::CertificateManager::Certificate]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-certificatemanager-certificate.html
[AWS::CloudFront::Distribution]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distribution.html
[AWS::Route53::HostedZone]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-route53-hostedzone.html
[AWS::Route53::RecordSetGroup]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-route53-recordsetgroup.html
[aws-cli]: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html
