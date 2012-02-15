Adventure hub collects and curates your adventure so you can relive it later without interrupting the trip while you are on it.

Adventure travel is pretty cool.  For many of us, "adventuring" is a way to get away from the drudgery of daily life.  Whether we ride motorcycles, road trip, travel by air and visit exotic locations, we have a desire to chronicle our experience.  We take photos, videos, journals and keepsakes.  All of this data presents an interesting dilemma: we must wade through the piles of data we collect on our adventure to share it with others or the relive the adventure ourselfs.  thousands of photos need to be 

## Utility Priorities

Adventure Hub could be many many things, and in order to reign the scope in we have a list of the top three things that AHub should help you do.  If a feature doesn't help one of these three things, then it probably shouldn't exist.

1. Remember your trip
2. Aid in the creation of documentary after the trip
3. Share your trip as you are on it

# Crazy Ideas

- Use git as the db for event metadata.  This would make it easy to sync, be unstructured, and hand editable.  Use plumbing to provide.

# Challenges

- Storage management : we will be limited by storage on the trip.  The phones and computers will not have enough storage to record everything.  We will need to manage all of the data that comes in.

# Milestones

1.  _Event Extraction - Listing_:  Run a command line file that takes an input directory and analyzes and extracts a list of events.
2.  _Event Extraction - Media Creation_: The command line tool now creates media files associated with an event.
