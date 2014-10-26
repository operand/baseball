# README

Hi.

Here are some notes and thoughts from development, as well as instructions for
setting up and running the app and test suite.

Since the calculations required were very specific I decided it was best to keep
things simple and define a single class (Calculator) with methods specifically
tailored to answer those queries. I think that keeping it simple like this
would probably end up being the most flexible.

As for the assumption provided in the assignment that future requests of the
system will require data from a pitching file, adding this requirement would
likely only require the following steps:
  1. Add a new model and associated migration to represent the pitching stats.
  2. Add a line to the import\_csvs task to import the new data.
  3. Add to Calculator, whatever methods are desired to compute any new
     calculations.
  4. In the rake 'run' task, indicate which calculations to include in the
     output.

Okay, I didn't mention writing specs, but yes that actually should be step 0. :)

I've also written a few comments in places to help in understanding my
decisions. I always make sure to comment on any bit of code that might not be
immediately obvious to the reader. But I always try to make the code obvious if
I can, first.

Regarding the specs. You'll notice that I write some long specs and don't nest
them very much. I prefer writing specs this way. I know that the nested DSL
(particularly using 'context' to reuse setup/teardown) is one of the killer
features of RSpec, but I only nest 'context's sparingly. I find that specs
are harder to follow and understand if they are so spread out by being nested
deeply. So I take the route of writing large 'it' blocks and occasionally even
duplicating setup, because in my opinion, it makes it easier later on to jump
into that spec and quickly understand how it works and what it's testing. I
still stick with RSpec though, because other features of the DSL are very handy.


## Setting up and running the app

I'm assuming you have already downloaded the source and installed ruby. Note
that this application has been developed and tested on MRI ruby 2.1.3. To avoid
any potential issues, I'd suggest using the same version of ruby, though I
expect any version of ruby after 1.9 to be fine.

To run the app, change (cd) into the root directory of the application and execute:

      gem install bundler
      bundle install
      bundle exec rake setup


Then to output the requested statistics type:

      bundle exec rake run


## Running specs

First set up your testing database by executing:

      BASEBALL_ENV=test bundle exec rake run_migrations


And then run the specs using:

      bundle exec rspec


## Cheers!

Thanks, and I hope to hear from you!

-Dan

