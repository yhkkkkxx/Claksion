package com.claksion.app.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.stereotype.Service;

import java.util.Set;

@Slf4j
@Service
@RequiredArgsConstructor
public class SeatSelectService {
    private final RedisTemplate<String, Object> redisTemplate;

    public void addQueue(String seatId) {
        // 이미 선택된 좌석이라면 대기열에 추가하지 않음
        Set<Object> completedSeat = redisTemplate.opsForSet().members("completedSeat:" + seatId.split(":")[1]);
        if (completedSeat.contains(seatId)) {
            return;
        }

        final String people = Thread.currentThread().getName();
        final long now = System.currentTimeMillis();

        redisTemplate.opsForZSet().add(seatId, people, (int) now);
        log.info("{} 유저가 {} 자리를 선택했습니다. ({}초)", people, seatId, now);
    }

    public void publish(String seatKey) {
        Set<Object> users = redisTemplate.opsForZSet().range(seatKey, 0, 0);
        Object user = users.stream().toList().get(0);
        log.info("✅'{}'님이 {} 자리 선택에 성공했습니다!", user, seatKey);
        redisTemplate.delete(seatKey);
        redisTemplate.opsForSet().add("completedSeat:" + seatKey.split(":")[1], seatKey);
    }

//    public void changeKey(String key) {
//        ZSetOperations<String, Object> ops = redisTemplate.opsForZSet();

//        return zSetOps.rangeWithScores(key, 0, -1);

//        Set<String> value = ops.rangeWithScores()
//        log.info(value.toString());
//        if (value != null) {
//            ops.set(key+":complete", value);
//            redisTemplate.delete(key);
//        }


//        ZSetOperations<String, String> zSetOps = redisTemplate.opsForZSet();
//        Set<ZSetOperations.TypedTuple<String>> members = zSetOps.rangeWithScores(oldKey, 0, -1);
//
//        if (members != null && !members.isEmpty()) {
//            for (ZSetOperations.TypedTuple<String> member : members) {
//                zSetOps.add(newKey, member.getValue(), member.getScore());
//            }
        }
//    }






