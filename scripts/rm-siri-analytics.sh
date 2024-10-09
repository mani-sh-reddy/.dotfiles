#! /bin/bash

sudo rm -rfv ~/Library/Assistant/SiriAnalytics.db
sudo touch ~/Library/Assistant/SiriAnalytics.db
sudo chmod -R 000 ~/Library/Assistant/SiriAnalytics.db
sudo chflags -R uchg ~/Library/Assistant/SiriAnalytics.db