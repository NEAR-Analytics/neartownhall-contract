use crate::social_db::{ext_social_db, SOCIAL_DB};
use crate::PostId;
use near_sdk::serde_json::json;
use near_sdk::{env, AccountId, Promise};

pub fn notify_like(post_id: PostId, post_author: AccountId) -> Promise {
    notify(post_id, post_author, "like")
}

pub fn notify_reply(post_id: PostId, post_author: AccountId) -> Promise {
    notify(post_id, post_author, "reply")
}

pub fn notify_edit(post_id: PostId, post_author: AccountId) -> Promise {
    notify(post_id, post_author, "edit")
}

fn notify(post_id: PostId, post_author: AccountId, action: &str) -> Promise {
    ext_social_db::set(
        json!({
            env::predecessor_account_id() : {
                "index": {
                    "notify": json!({
                        "key": post_author,
                        "value": {
                            "type": format!("near-analytics/{}", action),
                            "post": post_id,
                        },
                    }).to_string()
                }
            }
        }),
        &SOCIAL_DB,
        env::attached_deposit(),
        env::prepaid_gas() / 2,
    )
}
