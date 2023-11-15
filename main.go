package main

import (
	"fmt"

	"github.com/IBM/sarama"
)

func main() {
	//1.生产者配置
	config := sarama.NewConfig()
	config.Producer.RequiredAcks = sarama.WaitForAll          //ACK,发送完数据需要leader和follow都确认
	config.Producer.Partitioner = sarama.NewRandomPartitioner //分区,新选出一个分区
	config.Producer.Return.Successes = true                   //确认,成功交付的消息将在success channel返回

	//2.连接Kafka

	client, err := sarama.NewSyncProducer([]string{"127.0.0.1:39092"}, config)
	if err != nil {
		fmt.Println("Producer error", err)
		return
	}

	defer client.Close()

	//3.封装消息

	msg := &sarama.ProducerMessage{}
	msg.Topic = "log"
	msg.Value = sarama.StringEncoder("this is test log")

	//4.发送消息
	pid, offset, err := client.SendMessage(msg)

	if err != nil {
		fmt.Println("send failed", err)
	}
	fmt.Printf("pid:%v offset:%v\n", pid, offset)
}
