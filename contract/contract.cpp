/**
 *  @file
 *
 * 1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
 * 1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
 * 1188888881111888888811118888888111188888811111881111111111888881111118888811111888888811
 * 1188111111111881118811118811111111188111881111881111111118811188131188111881111881111111
 * 1188111111111881118811118111111111188111881111881111111118811188111188111111111881111111
 * 1188888811111881118811118888888111188888811111881111111118888888111188111111111888888111
 * 1188111111111881118811111111188111188111111111881111111118811188111188111111111881111111
 * 1188111111111881118811111111188111188111111111881111111118811188111188111881111881111111
 * 1188888881111888888811118888888111188111111111888888811118811188111118888811111888888811
 * 1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
 * 1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
 */

#include <utility>
#include <vector>
#include <string>
#include <eosiolib/eosio.hpp>
#include <eosiolib/asset.hpp>
#include <eosiolib/contract.hpp>
#include <eosiolib/time.hpp>
#include <eosiolib/print.hpp>
#include <eosiolib/transaction.hpp>

#include "../../common/mydate.hpp"
#include "../../common/utils.hpp"

#define EOS_SYMBOL S(4,EOS) 

using namespace eosio;

class bolao : public eosio::contract
{
  const uint8_t __OPEN = 1;
  const uint8_t __DEADLINE = 2;
  const uint8_t __CLOSED = 3;

  const account_name contract_fee_account = N(feebarbeting);

public:
  using contract::contract;

  bolao(account_name self) : contract(self) {}

  //@abi action
  void relgameram(const uint64_t idgame) {
    //verify authentication
    require_auth(_self);

    //find game to finalize
    game_index games(_self, _self);
    auto itgame = games.find(idgame);
    eosio_assert(itgame != games.end(), "Game not found");
    const auto &game = *itgame;
    
    //find bets to game identified by idgame
    bet_index bets(_self, _self);
    auto index = bets.get_index<N(idgame)>();

    auto itbet = index.find(idgame);
    int count = 0;
    while (itbet != index.end()){
      if (itbet->idgame != idgame)
        break;
      
      ++itbet;
      count ++;
    }

    if (count > 0) {
      eosio_assert(game.status == __CLOSED, "Game not closed");

      auto itbet = index.find(idgame);

      while (itbet != index.end()){
        if (itbet->idgame != idgame)
          break;
     
        itbet = index.erase(itbet);
      }

      games.erase(game);
    } else {
      games.erase(game);
    }
  }

  //@abi action
  void finalize(const uint64_t idgame,
                const uint32_t score1,
                const uint32_t score2)
  {
    //verify authentication
    require_auth(_self);

    //find game to finalize
    game_index games(_self, _self);
    auto itgame = games.find(idgame);
    eosio_assert(itgame != games.end(), "Game not found");
    const auto &game = *itgame;
    
    eosio_assert(game.status != __CLOSED, "Game closed");

    //update game status
    updategamest(idgame);

    //find bets to game identified by idgame
    bet_index bets(_self, _self);
    auto index = bets.get_index<N(idgame)>();
    auto itbet = index.find(idgame);

    //count number of bets and number of winners
    uint64_t nbets = 0;
    uint64_t winner = 0;
    uint64_t amount = 0;
    uint64_t amount_winner = 0;

    for (; itbet != index.end(); ++itbet)
    {
      if (itbet->idgame != idgame)
        break;

      nbets++;
      amount += itbet->value.amount;
      if (itbet->score1 == score1 && itbet->score2 == score2 && itbet->idgame == idgame)
      {
        winner++;
        amount_winner += itbet->value.amount;
      }
    }

    eosio_assert(nbets > 0, "Game without bets");
    eosio_assert(amount > 0, "Zero bet values");

    //Calculate amount of token in bets and fee
    uint64_t fee = amount * game.fee / 100;
    uint64_t amountliquid = amount - fee;

    player_index players(_self, _self);

    if (winner == 0)
    { //make distribution where no winner

      //find bets into idgame
      itbet = index.find(idgame);
      for (; itbet != index.end(); ++itbet)
      {
        if (itbet->idgame != idgame)
          break;
        // pay player
        auto itplayer = players.find(itbet->player);
        if (itplayer == players.end())
        {
          players.emplace(_self, [&](auto &p) {
            p.id = itbet->player;
            p.eos_balance = asset(itbet->value.amount * amountliquid / amount, EOS_SYMBOL);
          });
        }
        else
        {          
          const auto &winplayer = *itplayer;
          players.modify(winplayer, 0, [&](auto &a) {         
            a.eos_balance += asset(itbet->value.amount * amountliquid / amount, EOS_SYMBOL);
          });
        }
      }
    }
    else
    { //make distribution to winners
      itbet = index.find(idgame);
      for (; itbet != index.end(); ++itbet)
      {
        if (itbet->idgame != idgame)
          break;

        if (itbet->score1 == score1 && itbet->score2 == score2)
        {
          // pay player
          auto itplayer = players.find(itbet->player);

          if (itplayer == players.end())
          {
            players.emplace(_self, [&](auto &p) {
              p.id = itbet->player;
              p.eos_balance = asset(itbet->value.amount * amountliquid / amount_winner, EOS_SYMBOL);
            });
          }
          else
          {
            const auto &winplayer = *itplayer;
            players.modify(winplayer, 0, [&](auto &a) {
              a.eos_balance += asset(itbet->value.amount * amountliquid / amount_winner, EOS_SYMBOL);
            });
          }
        }
      }
    }

    games.modify(game, 0, [&](auto &g) {
      g.status = __CLOSED;
    });

    asset fee_asset(fee, EOS_SYMBOL);    
    action(permission_level{_self, N(active)},
           N(eosio.token), N(transfer),
           std::make_tuple(_self, contract_fee_account, fee_asset, std::string("__FEE")))
        .send();
  }

  /*
  //@abi action
  void newbet(const account_name from,
              const uint64_t idgame,
              uint32_t score1,
              uint32_t score2,
              const asset &value)
  {
    newbet_aux(from,
               idgame,
               score1,
               score2,
               value);

    //inline transaction to transfer funds
    action(
        permission_level{from, N(active)},
        N(eosio.token), N(transfer),
        std::make_tuple(from, _self, value, std::string("__NEWBET")))
        .send();
  }
  */
  
  //@abi action
  void claim(const account_name name)
  {
    require_auth(name);

    player_index players(_self, _self);
    auto itplayer = players.find(name);
    eosio_assert(itplayer != players.end(), "Player not found");
    const auto &player = *itplayer;

    auto amount = player.eos_balance;

    players.erase(player);

    action(permission_level{_self, N(active)},
           N(eosio.token), N(transfer),
           std::make_tuple(_self, name, amount, std::string("__CLAIM")))
        .send();
  }

  //@abi action
  void newgame(
      const std::string description,
      const std::string team1,
      const std::string team2,
      const uint8_t fee,
      const asset &value_min,
      const asset &value_max,
      const uint16_t bet_until_year,
      const uint8_t bet_until_month,
      const uint8_t bet_until_day,
      const uint8_t bet_until_hour,
      const uint8_t bet_until_minute,
      const std::string tags,
      const std::string &location)
  {
    require_auth(_self);

    eosio_assert(value_min.symbol == EOS_SYMBOL, "token not allowed");
    eosio_assert(value_min.is_valid(), "invalid bet");
    eosio_assert(value_min.amount > 0, "must bet positive quantity");

    eosio_assert(value_max.symbol == EOS_SYMBOL, "token not allowed");
    eosio_assert(value_max.is_valid(), "invalid bet");
    eosio_assert(value_max.amount > 0, "must bet positive quantity");

    eosio_assert(value_min < value_max, "Max value must be greater than min value");

    eosio_assert(description.size() > 0, "Empty description");
    eosio_assert(team1.size() > 0, "empty team1");
    eosio_assert(team2.size() > 0, "empty team2");
    eosio_assert(fee <= 100, "Fee must be an percentage");

    auto tn = eosio::time_point_sec(now());
    auto bet_until = time_point_sec(getUnixTimeStamp(bet_until_year,
                                                     bet_until_month,
                                                     bet_until_day,
                                                     bet_until_hour,
                                                     bet_until_minute,
                                                     0));
    eosio_assert(bet_until.utc_seconds > 0, "error checking bounds");
    eosio_assert(tn < bet_until, "now greatest bet until");

    game_index games(_self, _self);
    uint64_t newid = games.available_primary_key();
    games.emplace(_self, [&](auto &g) {
      g.id = newid;
      g.description = description;
      g.team1 = team1;
      g.team2 = team2;
      g.value_min = value_min;
      g.value_max = value_max;
      g.status = __OPEN;
      g.bet_until = bet_until;
      g.created_at = tn;
      g.fee = fee;
      g.tags = tags;
      g.location = location;
    });

    // schedulling game until - THINK ABOUT
    /*transaction tinit(bet_until);
    tinit.actions.emplace_back(permission_level{_self, N(active)},
			       _self, N(updategamest),
			       std::make_tuple(newid));
    tinit.send(_self, _self);*/
  }

  //@abi action
  void updategamest(const uint64_t id)
  {
    //require_auth(_self);

    game_index games(_self, _self);
    auto itgame = games.find(id);
    eosio_assert(itgame != games.end(), "Game not found");
    const auto &game = *itgame;

    if (game.status == __CLOSED)
      return;

    uint8_t next = game.status;
    auto tn = eosio::time_point_sec(now());
    if (game.bet_until <= tn)
    {
      next = __DEADLINE;
    }

    if (game.status != next)
    {
      games.modify(game, 0, [&](auto &g) {
        g.status = next;
      });
    }
  }

  //@abi action
  void transfer(account_name from,
              account_name to,
              asset        quantity,
              std::string  memo ){

    if(memo == "NOBET")
        return;

    if(memo == "__CLAIM")
        return;

    if(memo == "__NEWBET")
        return;

    if(memo == "__FEE")
        return;

    vector<string> v;
    split(memo, ',', v);

    eosio_assert(v.size() == 3, "wrong memo format");
    
    uint64_t ig = std::strtoul(v[0].c_str(), NULL, 10);
    uint64_t sc1 = std::strtoul(v[1].c_str(), NULL, 10);
    eosio_assert(sc1 <= 10, "Score1 too big");

    uint64_t sc2 = std::strtoul(v[2].c_str(), NULL, 10);
    eosio_assert(sc2 <= 10, "Score2 too big");    

    newbet_aux(from, ig, sc1, sc2, quantity);
  }

private:

void newbet_aux(const account_name from,
            const uint64_t idgame,
            uint32_t score1,
            uint32_t score2,
            const asset &value){
    require_auth(from);

    updategamest(idgame);

    game_index games(_self, _self);
    auto itgame = games.find(idgame);
    eosio_assert(itgame != games.end(), "Game not found");
    const auto &game = *itgame;
    
    eosio_assert(game.value_max >= value, "bet too big");
    eosio_assert(game.value_min <= value, "bet too small");
    eosio_assert(game.status == __OPEN, "Not open for betting");

    //find bets to game identified by idgame
    bet_index bets(_self, _self);
    auto index = bets.get_index<N(idgame)>();
    auto itbet = index.find(idgame);
    for (; itbet != index.end(); ++itbet) {
      if (itbet->idgame != idgame) break;
      eosio_assert(itbet->player != from, "This account just have a bet");  
    }

    bets.emplace(_self, [&](auto &b) {
      b.id = bets.available_primary_key();
      b.idgame = idgame;
      b.player = from;
      b.score1 = score1;
      b.score2 = score2;
      b.value = value;
      b.created_at = eosio::time_point_sec(now());
    });
}

  //@abi table game i64
  struct game
  {
    uint64_t id;
    std::string description;
    eosio::time_point_sec created_at;
    eosio::time_point_sec bet_until;
    std::string team1;
    std::string team2;
    std::string location;
    uint8_t fee;
    asset value_min;
    asset value_max;
    uint8_t status;
    std::string tags;

    uint64_t primary_key() const { return id; }

    EOSLIB_SERIALIZE(game,
                     (id)(description)(created_at)(bet_until)(team1)(team2)(location)(fee)(value_min)(value_max)(status)(tags))
  };
  typedef eosio::multi_index<N(game),
                             game>
      game_index;

  //@abi table bet i64
  struct bet
  {
    uint64_t     id;
    uint64_t     idgame;
    account_name player;
    uint32_t     score1;
    uint32_t     score2;
    asset        value;
    eosio::time_point_sec created_at;

    uint64_t primary_key() const { return id; }
    uint64_t get_game_key() const { return idgame; }

    EOSLIB_SERIALIZE(bet,
                     (id)(idgame)(player)(score1)(score2)(value)(created_at))
  };
  typedef eosio::multi_index<N(bet), bet,
                             eosio::indexed_by<N(idgame),
                                               eosio::const_mem_fun<
                                                   bet,
                                                   uint64_t,
                                                   &bet::get_game_key>>>
      bet_index;

  //@abi table player i64
  struct player
  {
    account_name id;
    asset eos_balance;

    uint64_t primary_key() const { return id; }
    //account_name get_owner_key()const { return owner; }

    EOSLIB_SERIALIZE(player, (id)(eos_balance))
  };

  typedef eosio::multi_index<N(player), player> player_index;
};

// https://eosio.stackexchange.com/q/421/54
#define EOSIO_ABI_EX( TYPE, MEMBERS ) \
extern "C" { \
   void apply( uint64_t receiver, uint64_t code, uint64_t action ) { \
      if( action == N(onerror)) { \
         /* onerror is only valid if it is for the "eosio" code account and authorized by "eosio"'s "active permission */ \
         eosio_assert(code == N(eosio), "onerror action's are only valid from the \"eosio\" system account"); \
      } \
      auto self = receiver; \
      if( code == self || code == N(eosio.token) || action == N(onerror) ) { \
         TYPE thiscontract( self ); \
         switch( action ) { \
            EOSIO_API( TYPE, MEMBERS ) \
         } \
         /* does not allow destructor of thiscontract to run: eosio_exit(0); */ \
      } \
   } \
}

EOSIO_ABI_EX(bolao, 
   (newgame)
   //(newbet)
   (finalize)
   (claim)
   (updategamest)
   (relgameram)
   
   (transfer)
   )
