# HTML template for test providers

## Portal

Inside the directory `portal` you can find the 

- HTML with inline CSS
- fonts
- images

for the portal of the testprovider. You can copy this code and use it within your pages. 

### How to use this template 

- copy the HTML to your HTML template and replace the zzz-code (in our example, `ZZZ-3839287252-F1`) with your generated code:
  - Once in the visible section (line `179`)
  - Once in the deeplink (line `188`)
- include the CSS and assets in the appropriate place for your website platform
- change the header level on line `175` and `177` to the appropriate level within your website (h2, h3, h4), to keep the code accessible

### Differences between the desktop and mobile versions

The template has two important differences for desktop and mobile devices:

- on desktop we show an instruction text
- on mobile we show a button with a `deeplink` to coronacheck.nl to redeem a code

We use the classes `.test-provider-portal__hide-for-mobile` and `.test-provider-portal__hide-for-desktop` to implement these differences.

## Mail

Inside the directory `mail` there is the design for the e-mail template.

## Zivver

Inside the directory `zivver` there is an example HTML template that can be used with the Zivver platform.

The Zivver platform has limited support for HTML e-mail. A lot of the styling elements are removed for security reasons.

Including stylesheets and loading external resources such as fonts is not supported. For this reason this template makes use of inline styling elements
and some modifications to get a user experience that comes close to the provided layout in this repository.

In order to use this with Zivver, the "Mail Submission" module needs to be enabled to allow sending messages via SMTP.


