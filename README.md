Follow Sweeper
=============

Finds twitter accounts that I'm following that haven't updated in 6 months so I can choose to unfollow them.

###Why Follow Sweeper?

Twitter has a crazy rule that unless your follower:following ratio is over some super secret ratio then you can't follow more than 2000 people. I was at that limit, so I was unable to follow new people. I knew that there were some Twitter accounts that I was following that were inactive, but there is no easy way to find which accounts were inactive.

###What is Follow Sweeper?

Follow Sweeper is a command-line Ruby app that outputs a list of Twitter user names that haven't updated their status in over 6 months.

###How to use Follow Sweeper

To use Follow Sweeper you need...
* Twitter API keys in a local file in the same directory as followsweeper.rb named tokens.rb
  * tokens.rb will initialize the following variables: 
    * MY_CONSUMER_KEY
    * MY_CONSUMER_SECRET
    * MY_ACCESS_TOKEN
    * MY_ACCESS_SECRET
* Ruby environment
* Approximately 2 hours for the app to get through 2000 friend accounts
* After running followsweeper.rb, open the "oldfriends.txt" file to see a list of inactive accounts.
