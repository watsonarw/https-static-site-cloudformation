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
   - _Note: this needs to be done in order for the automatic TLS certificate validation to work. If your Domain is not pointed to the AWS nameservers, the deployment will hang for over an hour while it tries to validate domain ownership in order to issue the TLS certificate before it eventually gives up._
   1) If you're creating a new Hosted Zone (and haven't passed in the `--hosted-zone-id` flag), the Nameservers will be output to the terminal before the main Cloudformation stack starts provisioning.
   2) Tell your domain registrar to use these name servers for your URL (this is usually done from within your domain registrar's portal)
3) **Wait for the script to finish (it might take a while).**


### Options

For full usage instructions, run
```sh
./provision --help
```

#### Tags

Tags can be added to the CloudFormation stack (which will automatically tag all supported resources in the stack) with the `--tag` or `--tags` flags:
```bash
./provision example.com --tag "Environment=production" --tag "Team=MyTeam"

./provision example.net --tags "Environment=production Team=MyTeam"
```

These flags can be combined and used multiple times, and all tags will be applied

```bash
./provision example.com --tag "Environment=production" --tags "Domain=web Product=web" -tag "Team=MyTeam"
```
is equivalent to
```bash
./provision example.com --tags "Environment=production Domain=web Product=web Team=MyTeam"
```

When CloudFormation applies the tags, the last value for the key will be set, e.g.
```bash
./provision example.com --tags "Environment=test Environment=production"
```

will set the `Environment` tag with the value `production`


### URI Canonicalization

By default, the CloudFront distribution includes URI canonicalization that will do the following redirects to improve SEO:
- Normalizes multiple consecutive slashes (`/path//to/page/` → `/path/to/page/`) - these are invalid paths anyway and S3 can't serve them
- Redirects extensionless paths to directory format (`/about` → `/about/`) - directories will serve the `index.html` file from the directory
- Redirects trailing `index.html` to the directory (`/about/index.html` → `/about/`)

To disable URI canonicalization if you need non-standard URI handling (e.g. if your site uses extensionless files):
```bash
./provision example.com --no-canonical-uris
```

### Security Headers
By default, the following security headers will be added to responses
- `Strict-Transport-Security: max-age=31536000;`
- `X-Content-Type-Options: nosniff`
- `Referrer-Policy: strict-origin-when-cross-origin`
- `Cross-Origin-Opener-Policy: same-origin-allow-popups`
- `Content-Security-Policy: frame-ancestors 'self'`

These headers add some security benefits while being minimally restrictive, and are unlikely to cause issues. In some cases, these headers might cause problems (e.g. if pages from your site are embedded in IFrames on another site, or in some SSO/Payment flows), so these headers can be disabled with:
```bash
./provision example.com --no-security-headers
```

#### Content Security Policy

The default content security policy is deliberately permissive so as not to cause issues, and really only prevents embedding pages in cross-origin IFrames. If you want something more restrictive, you can do so with a meta tag in your pages e.g.
```html
<meta http-equiv="Content-Security-Policy" content="default-src 'self'; img-src 'self' https: data:;">
```

Alternatively, the CSP header for all pages can be set with:
```bash
./provision example.com --csp-policy "default-src 'self'; img-src 'self' https: data:; frame-ancestors 'none'"
```

[Cloudformation]: https://aws.amazon.com/cloudformation/
[AWS::S3::Bucket]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket.html
[AWS::S3:BucketPolicy]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-policy.html
[AWS::CertificateManager::Certificate]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-certificatemanager-certificate.html
[AWS::CloudFront::Distribution]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distribution.html
[AWS::Route53::HostedZone]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-route53-hostedzone.html
[AWS::Route53::RecordSetGroup]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-route53-recordsetgroup.html
[aws-cli]: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html
