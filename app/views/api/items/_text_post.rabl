extends "api/items/post_base"

node(:text) { |post| post.postable.body }
