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

## Usage
### Synopsis

```sh
./provision [options] <site-name>
```

### Prerequisites

- You'll need the [aws-cli] installed to run the provision script.
- You'll need access to the AWS console to validate the TLS certificate.

### Instructions

**Note: If you let the script create a new Route53 Hosted Zone, you'll have to do some manual steps while the script is running**

1) **Run the provision script with the domain name you're using for your static site, and any desired options.**
   - For example, the domain name you're using is `example.com`, run `./provision "example.com"`
   - See [Options](#options) for more details
2) **Point Your DNS at the Route53 Name Servers**
   - _Note: this needs to be done while the Cloudformation stack is being provisioned in order for the automatic TLS certificate validation to work_
   1) Open up the AWS console and go to Route53
   2) Find the Hosted Zone that has been created by the script, and find the `NS` type record in the hosted zone - these are your nameservers
   3) Tell your domain registrar to use these name servers for your URL (this is usually done from within your domain registrar's portal)
3) **Wait for the script to finish (it might take a while).**


### Options

For full usage instructions, run
```sh
./provision --help
```

### URI Canonicalization

By default, the CloudFront distribution includes URI canonicalization that will do the following redirects to improve SEO:
- Normalizes multiple consecutive slashes (`/path//to/page/` → `/path/to/page/`) - these are invalid paths anyway and S3 can't serve them
- Redirects extensionless paths to directory format (`/about` → `/about/`) - directories will serve the `index.html` file from the directory
- Redirects trailing `index.html` to the directory (`/about/index.html` → `/about/`)

To disable URI canonicalization if you need non-standard URI handling (e.g. if your site uses extensionless files):
```bash
./provision example.com --no-canonical-uris
```

[Cloudformation]: https://aws.amazon.com/cloudformation/
[AWS::S3::Bucket]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket.html
[AWS::S3:BucketPolicy]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-policy.html
[AWS::CertificateManager::Certificate]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-certificatemanager-certificate.html
[AWS::CloudFront::Distribution]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distribution.html
[AWS::Route53::HostedZone]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-route53-hostedzone.html
[AWS::Route53::RecordSetGroup]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-route53-recordsetgroup.html
[aws-cli]: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html
