import static java.lang.System.out;

public class Abs {
	
	private static final int MIN_INTEGER = Integer.MIN_VALUE;
	private static final int MAX_INTEGER = Integer.MAX_VALUE;
	
	public static void main(String[] args) {
		if (args.length != 1) {
			System.exit(1);
		}
		if ("minInteger".equals(args[0])) {
			out.println(MIN_INTEGER);
		} else if ("maxInteger".equals(args[0])) {
			out.println(MAX_INTEGER);
		} else if ("absOfMinInteger".equals(args[0])) {
			out.println(Math.abs(MIN_INTEGER));
		} else {
			throw new IllegalArgumentException("Wot u said?");
		}
	}
	
}
