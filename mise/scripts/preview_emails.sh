#!/bin/bash

dc run --rm maizzle npm run build

# source="vendor/maizzle/build_production/mailer/*"
# destination="app/views/devise/mailer/"
# cp -r ${source} ${destination}

# source="vendor/maizzle/build_production/user_mailer/*"
# destination="app/views/pay/user_mailer/"
# cp -r ${source} ${destination}
