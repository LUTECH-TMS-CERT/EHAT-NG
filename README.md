# EHAT-NG (formerly SERPICO)

EHAT is the short name for Ethical Hacking Activity Tracking platform, developed by LUTECH-TMS-CERT years ago.
Actually, EHAT-NG is definitely more than just an activity tracking tool. It's SERPICO-on-steroids:
* Import XML report from Nexpose
* New Statistics & Charts
* New risk scoring system w/ auto CVSS Calculator
* Generate Remediation Plan in XLSX
* Auto Summarize of findings overview thanks to NLP (Natural Language Processing)
* ..and much more

EHAT-NG has been developed by LUTECH-TMS-CERT, largely thanks to the contribution of its Andrea De Dominicis. Andrea has another SERPICO fork on Github.
LUTECH-TMS-CERT decided to release EHAT-NG in opensource for the benefit of all.
LUTECH-TMS-CERT is willing to collaborate with the community to make it grow and is looking for technical joint ventures with other organizations to proactively support the community and evolve the project.

You may contact LUTECH-TMS-CERT at security at lutech dot it

## Installation

The installation commands for an Ubuntu 16.04.2 LTS are:

Install required packages:
```
sudo apt-get install git ruby ruby-dev build-essential make pkg-config libxml2-dev libglib2.0-dev libsqlite3-dev bundler
```

Clone git repository:
```
git clone https://github.com/LUTECH-TMS-CERT/EHAT-NG.git
```

Install EHAT-NG dependencies:
```
cd EHAT-NG && bundler install
```

Clone repository of dm-types library:
```
cd .. && git clone -b "gem-v1.2.2-with-frozen-nilclass-fix" https://github.com/julienma/dm-types.git
```

Install dm-types library:
```
cd dm-types && gem build dm-types.gemspec && sudo gem install dm-types-1.2.2.gem
```

## Post-Installation Releases : Getting Started

### Ubuntu 16.04.2 LTS

Launch the first_time.rb script (in order to initialize the database) and follow the instructions:
```
cd EHAT-NG && ruby scripts/first_time.rb
```

And then start EHAT-NG (HTTPS, 8443 port, on all interfaces by default):
```
cd EHAT-NG && ruby serpico.rb &
```

# Serpico
## SimplE RePort wrIting and CollaboratiOn tool
Serpico is a penetration testing report generation and collaboration tool. It was developed to cut down on the amount of time it takes to write a penetration testing report.

Video Demo of Functionality:

* [Serpico - Demo 1](https://www.youtube.com/watch?v=G_qYcL4ynSc)

* [Additional Video Demos](https://github.com/SerpicoProject/Serpico/wiki#online-demos)

## About Serpico
Serpico is at its core a report generation tool but targeted at creating information security reports. When building a report the user adds "findings" from the template database to the report. When there are enough findings, click 'Generate Report' to create the docx with your findings. The docx design comes from a Report Template which can be added through the UI; a default one is included. The Report Templates use a custom Markup Language to stub the data from the UI (i.e. findings, customer name, etc) and put them into the report.

## Features
#### Report Template Editing is Easy
**Philosophy: Editing a report template should be easy.**
During peer review we would constantly ran into "little things" we were fixing from the report template; an extra space here, a misspelling there. But it adds up. With Serpico, "fix" the report template, upload it back through the UI, and generate a new report; the error should be fixed permanently.

#### Template Database
**Philosophy: We do not need to write most findings from scratch.**
Most findings have been found in a previous assessment. In Serpico, all authors can pull findings from the template database and add to the report. A user can also 'Upload' a finding they made into the Template Database to share with everyone.

#### Attachment Collaboration
**Philosophy: It should be easy to share files with teammates.**
Use the 'Add Attachment' functionality to store a file (e.g. screenshots, nmap scans) or share with teammates on a pen test. No thumb drive swapping or e-mailing, just log into the UI and download the files. At the end of the assessment everything traded or generated for that assessment is in one place.


## Microsoft Word Meta-Language
The Meta language used for Microsoft Word was designed to be as simple as possible while still serving enough features to create a basic penetration test report.  That being said it has a learning curve (and many bugs) and I _highly_ suggest looking at "Serpico - Report.docx" or "Serpico - No DREAD.docx" and editing these rather than working from scratch.

See also:

* [Serpico Meta-Language In Depth](https://github.com/SerpicoProject/Serpico/wiki/Serpico-Meta-Language-In-Depth)

* [Inserting Screenshots](https://github.com/SerpicoProject/Serpico/wiki/Inserting-Screenshots): This is an area we know needs development so e-mail us with any ideas.


## Support
* [Wiki](https://github.com/MooseDojo/Serpico/wiki): We try to add most common questions to the wiki.
* [IRC: #therealserpico](http://webchat.freenode.net/?channels=%23therealserpico&uio=d4) on freenode
* [Issue](https://github.com/SerpicoProject/Serpico/issues/new) : If you have found a bug or would like a new feature
* [E-mail Support](https://www.serpicoproject.com/purchase/): For teams of users or template related questions

## GOTCHAS
* Microsoft has a really annoying habit of changing a character for you. Always beware of this when working with the meta language
